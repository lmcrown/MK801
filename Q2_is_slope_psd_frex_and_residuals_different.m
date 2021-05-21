function [OUT,LFP]=Q2_is_slope_psd_frex_and_residuals_different
%saves artifact threshold- you could probably make a globals file to save
%this in
%Goal is to create a starter function that can be used to itterate and
%generate an average hippocampal PSD for saline and MK801 animals

%will want to downsample and detrend
%then remove artifacts
%then plot the PSD in an OUT file along with rat number, drug conditon

% clear all
OUT.aborted=false;

parts=strsplit(pwd,'\');
OUT.animal=parts{9}(1:4);
if strcmp(parts{8}(1:3),'PSD')==1
    OUT.day=strcat('0', parts{8}(end));
else
    OUT.day=parts{8}(end-1:end);
end

OUT.drug=parts{7};
% head = Read_nlx_header('HIPP-CSC7_4586135492_End.ncs');
% if csc=='hip'
PLOT_IT=0;

    file=find_files('*mPFC*.ncs');
    if isempty(file) && str2double(OUT.animal)>=1042
        file=find_files('CSC16*.ncs'); %nancy says for all animals 1042 and on that csc 8 is hippocampus, 16 is mpfc  12 is msn
    elseif isempty(file) && str2double(OUT.animal)<=1042
        OUT.aborted=true;
        disp('no  file found')
        return
    end
    
    %CSC 4 thalamus, CSC 12 MSN, CSC 8 HIPP, 19 MPFC
    
%     num=extractAfter(file{1},'HIPP-CSC');  %seems like not all have the
%     spilit file stuff so I"m just taking the end of it anyways, so I
%     might as well just take the whole file 
%     chan=num(1);
%     cd('Split-relabeled files\')
%     split_file=find_files(['CSC' chan '*']);
% end
downsample_fq=500;

[LFP,sFreq]=convert_dwnspl_detrend(file{1},downsample_fq); %second input is desired downsampled freq

endtime=LFP(end,1)-(2*60); %2 min before end
starttime=LFP(end,1)-(12*60);  %make 10 min range
ix=LFP(:,1)>starttime & LFP(:,1)<endtime;
% LFP_i=LFP(ix,:);
% figure
% plot(LFP(ix,1),LFP(ix,2))
% [~,y]=ginput(1);
% OUT.art_thresh=y;

    [BIX,artifact_times_usec] = LD_Clean_LFP(LFP(ix,:),[],6e4,downsample_fq);
    perc_bad = sum(BIX)/length(BIX);
    fprintf('BAD percent: %2.2f\n',perc_bad*100)
    if perc_bad > .3 %if its grabbing 10 minutes this means that ill get 6
        disp('Too much bad data')
        OUT.aborted=true;
        return
    end

   newLFP=LFP(~BIX,:) ;              
             

%save the LFP snip that you have so that you don't need to download again

if PLOT_IT==1
 figure
plot(newLFP(:,1),newLFP(:,2))
xlabel('Seconds')
end


% LFP(:,2)=LFP_mv;
 [pxx,f] =pmtm(LFP(ix,2),5,[2:0.5:120],sFreq);
 [pxx_noart,f] =pmtm(newLFP(:,2),5,[2:0.5:120],sFreq);
 
     new_num=mean([pxx_noart(f==59),pxx_noart(f==61)]);
    pxx(f==60)=new_num;
    new_num2=mean([pxx_noart(f==119),pxx_noart(f==121)]);
    pxx_noart(f==120)=new_num2;
    dbpxx=10*log10(pxx_noart);
 
    
        b_coeffs=robustfit(f,dbpxx);
    
        b_coeffs_lg=robustfit(f(f<55),dbpxx(f<55));
        b_coeffs_hg=robustfit(f(f>65 &f<90),dbpxx(f>65 &f<90));
        
            y_ep_lg=b_coeffs_lg(1)+(b_coeffs_lg(2)*f(f<55));
            y_ep_hg=b_coeffs_lg(1)+(b_coeffs_hg(2)*f(f>65 &f<90));

  OUT.resid_lg(:)=dbpxx(f<55)-y_ep_lg;
  OUT.resid_hg(:)=dbpxx(f>65 &f<90)-y_ep_hg;
    OUT.slope_lg=b_coeffs_lg(2);
    OUT.slope_hg=b_coeffs_hg(2);

    
    y_ep=b_coeffs(1)+(b_coeffs(2)*f);
    
  OUT.resid=dbpxx-y_ep;
    
    OUT.psd=pxx;
    OUT.dbpsd=dbpxx;
    OUT.freqs=f;
    OUT.model=y_ep;
    OUT.slope=b_coeffs(2);
    
 %find theta frequency with instafreq
[thetaFreq,t]=instfreq(newLFP(:,2),sFreq,'FrequencyLimits',[5 10]); %instafreq seems to want to work in seconds
thetafreq=median(thetaFreq);
OUT.thetafreq=thetafreq;

[lowgammafreq,t]=instfreq(newLFP(:,2),sFreq,'FrequencyLimits',[30 50]); %instafreq seems to want to work in seconds
lowgammaf=median(lowgammafreq);
OUT.lowgammafrex=lowgammaf;
%low gamma= 30-50
%high gamma= 130-180
[highgammafreq,t]=instfreq(newLFP(:,2),sFreq,'FrequencyLimits',[130 180]); %instafreq seems to want to work in seconds
highgammaf=median(highgammafreq);
OUT.highgammafrex=highgammaf;

    figure
    plot(f,OUT.dbpsd)
    hold on
    plot(f,OUT.model)
 
 figure;
 plot(f,10*log10(pxx))
hold on
plot(f,10*log10(pxx_noart))
legend('original','no art');
title(sprintf('Animal %s %s %s',OUT.animal, OUT.drug, OUT.day))
 %this would need to be changed depending on your path
OUT.pxx=pxx;
OUT.pxx_noart=pxx_noart;
OUT.frex=f;
LFPdata.lfp=newLFP;
% LFPdata.out=OUT;
%  place2save='E:\Darrin\Reduced_Files\PSD7_10min_pre'; %changing this for location
%  save([place2save '\Rat' OUT.animal],'LFPdata')

