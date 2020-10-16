function [OUT]=testing
%options hip, cort,thal,msn,mpfc

clear all
% head = Read_nlx_header('HIPP-CSC7_4586135492_End.ncs');
% if csc=='hip'
    file=find_files('*HIPP*_End.ncs');
% end
[LFP_end,sFreq]=convert_dwnspl_detrend(file{1},1000); %second input is desired downsampled freq
 [LFP_pre,sFreq]=convert_dwnspl_detrend('CSC5_0001_335114963529_End.ncs',1000); %second input is desired downsampled freq

% figure;
% plot(LFP(:,1),LFP(:,2))
PLOT_IT=1

% Artifact rejection
% [bad_start_end, good_start_end, BADIX, LFP_mv] = SPEC_artifact_detection(...
%     LFP(:,2), ...
%     sFreq, ...
%     3e4, ...
%     [], ...
%     [], ...
%     PLOT_IT);
% 
% LFP(:,2)=LFP_mv;
 [pxx,f] =pmtm(LFP_end(:,2),5,[2:0.5:120],sFreq);
 [pxx_pre,f] =pmtm(LFP_pre(:,2),5,[2:0.5:120],sFreq);
 
 figure;
 subplot 211
  plot(LFP_end(:,1),LFP_end(:,2))
 hold on
 plot(LFP_pre(:,1),LFP_pre(:,2))

subplot 212
 plot(f,10*log10(pxx))
 hold on
 plot(f,10*log10(pxx_pre))

 
 % MIGHT BE GOOD TO ELIMINATE ARTIFACTS
 
[thetaf,t]=instfreq(LFP_end(:,2),sFreq,'FrequencyLimits',[5 10]);  %instafreq seems to want to work in seconds
 thetaFreq_post=nanmean(thetaf);
 
 [thetaf,t]=instfreq(LFP_pre(:,2),sFreq,'FrequencyLimits',[5 10]);  %instafreq seems to want to work in seconds
 thetaFreq_pre=nanmean(thetaf);
 OUT.theta_freq_pre=thetaFreq_pre; %find peak theta
 OUT.thetaFreq_post=thetaFreq_post;

  Theta_filt = designfilt('bandpassiir','FilterOrder',12, ...
     'HalfPowerFrequency1',5, 'HalfPowerFrequency2',10, ...
     'SampleRate',Fs,'designmethod', 'butter');
 
 HighGamma = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',65, 'HalfPowerFrequency2',90, ...
    'SampleRate',sFreq,'designmethod', 'butter');
LowGamma = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',23, 'HalfPowerFrequency2',55, ...
    'SampleRate',sFreq,'designmethod', 'butter');


narrow_filt = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',thetaFreq-2, 'HalfPowerFrequency2',thetaFreq+2, ...
    'SampleRate',sFreq,'designmethod', 'butter');
Broad_filt = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',2, 'HalfPowerFrequency2',30, ...
    'SampleRate',sFreq,'designmethod', 'butter'); 
 
broad_lfp(:,1)=LFP_end(:,1);
narrow_lfp(:,1)=LFP_end(:,1);
broad_lfp(:,2)=filtfilt(Broad_filt,LFP_end(:,2));
narrow_lfp(:,2)=filtfilt(narrow_filt,LFP_end(:,2)); 

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
end

OUT.av_theta=nanmean(LFP_snip,1);

%% PAC
    theta_phase(:,2)=LFP_end(:,1);
    lg_power=LFP_end(:,1);
    hg_power(:,1)=LFP_end(:,1);
    theta_phase(:,2)=angle(hilbert(filtfilt(Theta_filt,LFP_end(:,2))));
    lg_power(:,2)=abs(hilbert(filtfilt(LowGamma,LFP_end(:,2))));
    hg_power(:,2)=abs(hilbert(filtfilt(HighGamma,LFP_end(:,2))));

      [paczl,~,~,~]= SPEC_cross_fq_coupling_pac_no_window_dpac(theta_phase(:,2),lg_power(:,2));
      [paczh,~,~,~]= SPEC_cross_fq_coupling_pac_no_window_dpac(theta_phase(:,2),hg_power(:,2));
      
OUT.paczl=paczl;
OUT.paczh=paczh;