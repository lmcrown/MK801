function [OUT]=Q1_is_theta_more_assym_after_drug_plus_theta_frex
%options hip, cort,thal,msn,mpfc
% clear all
OUT.aborted=false;
datadir=pwd;
parts=strsplit(pwd,'\');
OUT.animal=parts{9}(1:4);
OUT.drug=parts{7};
% head = Read_nlx_header('HIPP-CSC7_4586135492_End.ncs');
% if csc=='hip'
PLOT_IT=1;

file=find_files('*HIPP*.ncs');
if isempty(file) && str2double(OUT.animal)>=1042
    file=find_files('CSC8*.ncs'); %nancy says for all animals 1042 and on that csc 8 is hippocampus
elseif isempty(file) && str2double(OUT.animal)<=1042
    OUT.aborted=true;
    disp('no hippocampal file found')
    return
end
%     num=extractAfter(file{1},'HIPP-CSC');  %seems like not all have the
%     spilit file stuff so I"m just taking the end of it anyways, so I
%     might as well just take the whole file
%     chan=num(1);
%     cd('Split-relabeled files\')
%     split_file=find_files(['CSC' chan '*']);
% end
downsample_fq=1000;

[LFP,sFreq]=convert_dwnspl_detrend(file{1},downsample_fq); %second input is desired downsampled freq

%get artifact threshold from before
day=parts{8};
cd(['F:\Keck Medicine of USC\MK801_Results\plot_noart_psd\Hipp\' day ])
if strcmpi(parts{6}(end-7:end),'PREEinjs')
    f=find_files([OUT.animal '_PREEinjs.mat' ]);
        if isempty(f)
        OUT.aborted=1;
        disp('no animal file found')
        return
    end
    load(f{1})
    if Dset.aborted==1
        OUT.aborted=1;
        return
    else
        y=Dset.art_thresh;
    end
elseif strcmpi(parts{6}(end-7:end),'POSTinjs')
    f=find_files([OUT.animal '_POSTinjs.mat' ]);
    if isempty(f)
        OUT.aborted=1;
        disp('no animal file found')
        return
    end
    load(f{1})
    if Dset.aborted==1
        OUT.aborted=1;
        return
    else
        y=Dset.art_thresh;
    end
end
cd(datadir)
[BIX,artifact_times_usec] = LD_Clean_LFP(LFP,[],y,downsample_fq);
perc_bad = sum(BIX)/length(BIX);
fprintf('BAD percent: %2.2f\n',perc_bad*100)
if perc_bad > .3 %if its grabbing 10 minutes this means that ill get 6
    disp('Too much bad data')
    OUT.aborted=true;
    return
end
%

newLFP=LFP(~BIX,:) ;

endtime=LFP(end,1)-(2*60); %2 min before end
starttime=LFP(end,1)-(12*60);  %make 10 min range
ix=newLFP(:,1)>starttime & newLFP(:,1)<endtime;

% MIGHT BE GOOD TO ELIMINATE ARTIFACTS

[thetaf,t]=instfreq(newLFP(ix,2),sFreq,'FrequencyLimits',[5 10]);  %instafreq seems to want to work in seconds
thetaFreq=nanmean(thetaf);
OUT.theta_freq=thetaFreq; %find peak theta

Theta_filt = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',5, 'HalfPowerFrequency2',10, ...
    'SampleRate',sFreq,'designmethod', 'butter');


narrow_filt = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',thetaFreq-2, 'HalfPowerFrequency2',thetaFreq+2, ...
    'SampleRate',sFreq,'designmethod', 'butter');
Broad_filt = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',2, 'HalfPowerFrequency2',30, ...
    'SampleRate',sFreq,'designmethod', 'butter');

broad_lfp(:,1)=newLFP(ix,1);
narrow_lfp(:,1)=newLFP(ix,1);
broad_lfp(:,2)=filtfilt(Broad_filt,newLFP(ix,2));
narrow_lfp(:,2)=filtfilt(narrow_filt,newLFP(ix,2));

[phase, pk_ix, tr_ix, assym, updown_ix] = ...
    Phase_pow_fq_detector_waveshape(broad_lfp(:,2),narrow_lfp(:,2),sFreq);
%
% figure;
% plot(broad_lfp(:,1),broad_lfp(:,2))
OUT.assym=nanmean(assym(:,2));
LFP_snip=nan(length(pk_ix),999);
for ipeak=1:5:length(pk_ix)
    peaktime=broad_lfp(pk_ix(ipeak),1);
    time_range_ix=broad_lfp(:,1)> peaktime-0.5 & broad_lfp(:,1)< peaktime +0.5; %depends on the units of your time, right now units are seconds
    if sum(time_range_ix) ~= 999 %sample rate is 1000
        LFP_snip(ipeak,:)=nan(1,999);
        continue
    else
        LFP_snip(ipeak,:)=broad_lfp(time_range_ix,2);
    end
end
if PLOT_IT==1
    figure
    plot_confidence_intervals(LFP_snip)
    title(sprintf('Animal %s %s %s',OUT.animal,day, parts{6}(end-7:end)))
end

OUT.av_theta=nanmean(LFP_snip,1);

