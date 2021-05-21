% plot_noart_psd_frex_ANA

%Q2_Gamma_power_Ratio_across_trial

%Based on Q7_Does_Ratio_HighvLow_change_wleadup_to_stim_6_ANA
% ANA_dir='E:\Lindsey\Lesley_Data\Analysis\Lesley_data\Q7_Does_Ratio_HighvLow_change_wleadup_to_stim_6';
clear all
ANA_dir='F:\Keck Medicine of USC\MK801_Results\Acute\CFC_hipp_mpfc\PSD7';

cd(ANA_dir)

% GP=LD_Globals;
d = dir('1*.mat');
load(fullfile(ANA_dir,d(1).name),'Dset'); % load the first dataset to be sure things work.
ses_cnt=1;
ses = {};
for iF = 1:length(d)
    load(fullfile(d(iF).name),'Dset');
    if Dset.aborted==true 
        continue
    end
    ses{ses_cnt} = [num2str(iF) ',' Dset.animal ',' Dset.drug ','];
    fprintf('%s\n',ses{ses_cnt})
    %
    group{ses_cnt} = Dset.drug;
    animal(ses_cnt) = str2double( Dset.animal );
    st=strsplit(d(iF).name,'_');
    time{ses_cnt}=st{2}(1:4);
%       day_num(ses_cnt)=str2double(Dset.ses.name(end-1:end));
MI_hip2cort_hg(ses_cnt)=Dset.hip2cort_MI_theta_hg;
MI_hip2hip_hg(ses_cnt)=Dset.hip_MI_theta_hg;
pacz_hip2hip_hg(ses_cnt)=Dset.hip_paczh;
pacz_hip2hip_lg(ses_cnt)=Dset.hip_paczl;
pacz_hip2cort_hg(ses_cnt)=Dset.c2h_paczh;
pacz_hipcort_lg(ses_cnt)=Dset.c2h_paczl;
    ses_cnt = ses_cnt + 1;
end

group=categorical(group);
animal= categorical(animal);
time=categorical(time);
PREIX=time=='PREE';
POSTIX=time=='POST';
SIX=group=='SALIN';
MIX=group=='MK801';
[an,ix]=unique(animal);
grp=group(ix);

IXS= grp== 'SALIN';
IXM= grp== 'MK801';

[an,ix]=unique(animal);
%% MI for just post in saline and drug

figure
bar_plot_with_p_publish_updated(MI_hip2hip_hg,SIX&POSTIX,MIX&POSTIX,'Hip2Hip HG')

figure
bar_plot_with_p_publish_updated(MI_hip2cort_hg,SIX&POSTIX,MIX&POSTIX,'Hip2Cort HG')
%% Compare MI for PRE and POST, SALINE and MK801 -change in MI

for iani=1:length(an)
    ANIX=animal==an(iani);
    if sum(ANIX &PREIX) + sum(ANIX &POSTIX)~=2
        diff_MI_hip2hip(iani,:)=nan;
    else
        diff_MI_hip2hip(iani,:)=(MI_hip2hip_hg(ANIX & POSTIX,:)-MI_hip2hip_hg(ANIX & PREIX,:));
    end
end
%% OLD SHIT
% diff=nan(length(an),length(frex));
for iani=1:length(an) % MAYBE MAKE A ZSCORE?
    ANIX=animal==an(iani);
    if sum(ANIX &PREIX) + sum(ANIX &POSTIX)~=2
        difference(iani,:)=nan(1,length(frex));
    else
        difference(iani,:)=(pxx_no_art(ANIX & POSTIX,:)-pxx_no_art(ANIX & PREIX,:))./(pxx_no_art(ANIX & PREIX,:)+pxx_no_art(ANIX & POSTIX,:));
        difference(iani,BIX)=nan;
        theta_diff(iani,:)=(theta_delt(ANIX & POSTIX,:)-theta_delt(ANIX & PREIX,:))./(theta_delt(ANIX & PREIX,:)+theta_delt(ANIX & POSTIX,:));
        hg_diff(iani,:)=(hg_delt(ANIX & POSTIX,:)-hg_delt(ANIX & PREIX,:))./(hg_delt(ANIX & PREIX,:)+hg_delt(ANIX & POSTIX,:));
        lg_diff(iani,:)=(lg_delt(ANIX & POSTIX,:)-lg_delt(ANIX & PREIX,:))./(lg_delt(ANIX & PREIX,:)+lg_delt(ANIX & POSTIX,:));
        broad_diff(iani,:)=(broadgamma_pow(ANIX & POSTIX,:)-broadgamma_pow(ANIX & PREIX,:))./(broadgamma_pow(ANIX & PREIX,:)+broadgamma_pow(ANIX & POSTIX,:));

    end
end
%%
figure
bar_plot_with_p_publish_updated(hg_diff,IXS,IXM,'HighGamma')
figure
bar_plot_with_p_publish_updated(lg_diff,IXS,IXM,'LowGamma')
figure
bar_plot_with_p_publish_updated(theta_diff,IXS,IXM,'Theta')
figure
bar_plot_with_p_publish_updated(broad_diff,IXS,IXM,'BroadGamma')
figure
bar_plot_with_p_publish_updated(broadgamma_pow,IXS,IXM,'BroadGamma')
%%
figure
bar_plot_with_p_publish_updated(hg_delt,IXS,IXM,'HighGamma')
figure
bar_plot_with_p_publish_updated(lg_delt,IXS,IXM,'LowGamma')
figure
bar_plot_with_p_publish_updated(theta_delt,IXS,IXM,'Theta')
figure
bar_plot_with_p_publish_updated(broad_delt,IXS,IXM,'BroadGamma')
figure
bar_plot_with_p_publish_updated(broadgamma_pow,IXS,IXM,'BroadGamma')
%% PLOT pre and post for saline and MK801
figure;
subplot 211
plot_confidence_intervals(frex,10*log10(pxx_no_art(SIX & PREIX,:)),[],[0 0 1])
hold on
plot_confidence_intervals(frex,10*log10(pxx_no_art(MIX &PREIX ,:)),[],[1 0 0])
title('PRE')
subplot 212
plot_confidence_intervals(frex,10*log10(pxx_no_art(SIX &POSTIX,:)),[],[0 0 1])
hold on
plot_confidence_intervals(frex,10*log10(pxx_no_art(MIX &POSTIX,:)),[],[1 0 0])
title('POST')
equalize_axes
%% animal level differences
figure;
plot_confidence_intervals(frex,difference(IXS,:),[],[0 0 1])
hold on
plot_confidence_intervals(frex,difference(IXM ,:),[],[1 0 0])
title('Post-Pre / Post + Pre')

%% LOOK at just the post time periods for PSD8 and make comparisons between groups

figure;
bar_plot_with_p_publish_updated(thetafrex,SIX & POSTIX,MIX &POSTIX,'Theta')
xticklabels({'Saline' 'MK801'})
ylim([5 10])
figure;
bar_plot_with_p_publish_updated(lowgammafrex,SIX & POSTIX,MIX &POSTIX,'Low Gamma')
xticklabels({'Saline' 'MK801'})
ylim([30 50])
figure;
bar_plot_with_p_publish_updated(highgammafrex,SIX & POSTIX,MIX &POSTIX,'High Gamma')
xticklabels({'Saline' 'MK801'})
ylim([130 180])
