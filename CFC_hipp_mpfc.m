function [OUT]=CFC_hipp_mpfc
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
OUT.drug=parts{7};
OUT.day=parts{8};
% head = Read_nlx_header('HIPP-CSC7_4586135492_End.ncs');
% if csc=='hip'
PLOT_IT=0;

    file_hip=find_files('*HIPP*.ncs');
    if isempty(file_hip) && str2double(OUT.animal)>=1042
        file_hip=find_files('CSC8*.ncs'); %nancy says for all animals 1042 and on that csc 8 is hippocampus, 16 is mpfc
    elseif isempty(file_hip) && str2double(OUT.animal)<=1042
        OUT.aborted=true;
        disp('no hippocampal file found')
        return
    end
    
        file_cort=find_files('*mPFC*.ncs');
    if isempty(file_cort) && str2double(OUT.animal)>=1042
        file_cort=find_files('CSC16*.ncs'); %nancy says for all animals 1042 and on that csc 8 is hippocampus, 16 is mpfc
    elseif isempty(file_cort) && str2double(OUT.animal)<=1042
        OUT.aborted=true;
        disp('no cortical file found')
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

[LFP_hipp,sFreq]=convert_dwnspl_detrend(file_hip{1},downsample_fq); %second input is desired downsampled freq
[LFP_cort,sFreq]=convert_dwnspl_detrend(file_cort{1},downsample_fq);

endtime=LFP_hipp(end,1)-(2*60); %2 min before end
starttime=LFP_hipp(end,1)-(7*60);  %make 5 min range
ix=LFP_hipp(:,1)>starttime & LFP_hipp(:,1)<endtime;
% LFP_i=LFP(ix,:);
% figure
% plot(LFP(ix,1),LFP(ix,2))
% [~,y]=ginput(1);
% OUT.art_thresh=y;

    [BIX,artifact_times_usec] = LD_Clean_LFP(LFP_hipp(ix,:),[],6e4,downsample_fq);
    perc_bad = sum(BIX)/length(BIX);
    fprintf('BAD percent: %2.2f\n',perc_bad*100)
    if perc_bad > .3 %if its grabbing 10 minutes this means that ill get 6
        disp('Too much bad data')
        OUT.aborted=true;
        return
    end

    
    [BIX2,artifact_times_usec] = LD_Clean_LFP(LFP_cort(ix,:),[],6e4,downsample_fq);
    perc_bad = sum(BIX)/length(BIX);
    fprintf('BAD percent: %2.2f\n',perc_bad*100)
    if perc_bad > .3 %if its grabbing 10 minutes this means that ill get 6
        disp('Too much bad data')
        OUT.aborted=true;
        return
    end
       Hip=LFP_hipp(~BIX &~BIX2,:) ;              

   Cort=LFP_cort(~BIX &~BIX2,:) ;              
             
%% Theta phase gamma amplitude within hippocampus 



%save the LFP snip that you have so that you don't need to download again
% 
% if PLOT_IT==1
%  figure
% plot(newLFP(:,1),newLFP(:,2))
% xlabel('Seconds')
% end

Theta_filt = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',5, 'HalfPowerFrequency2',10, ...
    'SampleRate',sFreq,'designmethod', 'butter');
HighGamma = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',65, 'HalfPowerFrequency2',100, ...
    'SampleRate',sFreq,'designmethod', 'butter');
LowGamma = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',30, 'HalfPowerFrequency2',55, ...
    'SampleRate',sFreq,'designmethod', 'butter');


hgpow_hip=abs(hilbert(filtfilt(HighGamma,Hip(:,2))));
lgpow_hip=abs(hilbert(filtfilt(LowGamma,Hip(:,2))));
thetapow_hip=abs(hilbert(filtfilt(Theta_filt,Hip(:,2))));
theta_phase_hip=angle(hilbert(filtfilt(Theta_filt,Hip(:,2))));

hgpow_cort=abs(hilbert(filtfilt(HighGamma,Cort(:,2))));
lgpow_cort=abs(hilbert(filtfilt(LowGamma,Cort(:,2))));
thetapow_cort=abs(hilbert(filtfilt(Theta_filt,Cort(:,2))));


[~,~,~,hip_paczl]= SPEC_cross_fq_coupling_pac_no_window_dpac(theta_phase_hip,lgpow_hip); %dpac Z scored
[~,~,~,hip_paczh]= SPEC_cross_fq_coupling_pac_no_window_dpac(theta_phase_hip,hgpow_hip); 

[~,~,~,c2h_paczl]= SPEC_cross_fq_coupling_pac_no_window_dpac(theta_phase_hip,lgpow_cort); %dpac Z scored
[~,~,~,c2h_paczh]= SPEC_cross_fq_coupling_pac_no_window_dpac(theta_phase_hip,hgpow_cort); 


[MI,~]=modulationIndex(theta_phase_hip,hgpow_hip);
[MI_cort,~]=modulationIndex(theta_phase_hip,hgpow_cort);

OUT.hip_paczl=hip_paczl;
OUT.hip_paczh=hip_paczh;
OUT.hip_MI_theta_hg=MI;
OUT.hip2cort_MI_theta_hg=MI_cort;

OUT.c2h_paczl=c2h_paczl;
OUT.c2h_paczh=c2h_paczh;

% LFPdata.out=OUT;
%  place2save='E:\Darrin\Reduced_Files\PSD7_10min_pre'; %changing this for location
%  save([place2save '\Rat' OUT.animal],'LFPdata')

