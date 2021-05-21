% plot_noart_psd_frex_ANA

%Q2_Gamma_power_Ratio_across_trial

%Based on Q7_Does_Ratio_HighvLow_change_wleadup_to_stim_6_ANA
% ANA_dir='E:\Lindsey\Lesley_Data\Analysis\Lesley_data\Q7_Does_Ratio_HighvLow_change_wleadup_to_stim_6';
clear all
ANA_dir='F:\Keck Medicine of USC\MK801_Results\Acute\spectral_entropy_overfulltime\PSD7';

cd(ANA_dir)
clear diffrence
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
%   pxx_no_art(ses_cnt,:)=Dset.pxx_noart;
%  pxx(ses_cnt,:)=Dset.pxx;
med_entr(ses_cnt,:)= median(Dset.time_spec_ent(:,2));
mean_entr(ses_cnt,:)= trimmean_cowen(Dset.time_spec_ent(:,2));

time_entr(ses_cnt,:)=Dset.time_spec_ent(:,2);
 entrop(ses_cnt,:)=Dset.mean_se;
    ses_cnt = ses_cnt + 1;
end
frex=2:0.5:120; %change later to update with fnction

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
%%
[an,ix]=unique(animal);
BIX=frex>59.5 &frex<60.5;
difference=nan(length(an),length(frex));
ent_diff_mean=nan(length(an),1);
ent_diff_med=nan(length(an),1);

% diff=nan(length(an),length(frex));
for iani=1:length(an) % MAYBE MAKE A ZSCORE?
    ANIX=animal==an(iani);
    if sum(ANIX &PREIX) + sum(ANIX &POSTIX)~=2
        difference(iani,:)=nan(1,length(frex));
        ent_diff_mean(iani,:)=nan;
        ent_diff_med(iani,:)=nan;

    else
%         difference(iani,:)=(pxx_no_art(ANIX & POSTIX,:)-pxx_no_art(ANIX & PREIX,:))./(pxx_no_art(ANIX & PREIX,:)+pxx_no_art(ANIX & POSTIX,:));
%         difference(iani,BIX)=nan;
%         theta_diff(iani,:)=(theta_delt(ANIX & POSTIX,:)-theta_delt(ANIX & PREIX,:))./(theta_delt(ANIX & PREIX,:)+theta_delt(ANIX & POSTIX,:));
%         hg_diff(iani,:)=(hg_delt(ANIX & POSTIX,:)-hg_delt(ANIX & PREIX,:))./(hg_delt(ANIX & PREIX,:)+hg_delt(ANIX & POSTIX,:));
%         lg_diff(iani,:)=(lg_delt(ANIX & POSTIX,:)-lg_delt(ANIX & PREIX,:))./(lg_delt(ANIX & PREIX,:)+lg_delt(ANIX & POSTIX,:));
%         broad_diff(iani,:)=(broadgamma_pow(ANIX & POSTIX,:)-broadgamma_pow(ANIX & PREIX,:))./(broadgamma_pow(ANIX & PREIX,:)+broadgamma_pow(ANIX & POSTIX,:));
        ent_diff_med(iani,:)=med_entr(ANIX & POSTIX)-med_entr(ANIX & PREIX);
        ent_diff_mean(iani,:)=mean_entr(ANIX & POSTIX)-mean_entr(ANIX & PREIX);
    
    end
end
%%
figure
plot_confidence_intervals(1:length(time_entr),time_entr(SIX & POSTIX,:),[],[0 0 1])
hold on
plot_confidence_intervals(1:length(time_entr),time_entr(MIX & POSTIX,:),[],[1 0 0])

%%
figure
subplot 211
bar_plot_with_p_publish_updated(ent_diff_mean,IXS,IXM,'Entropy Post-Pre Trimmed mean',true)
xticklabels({'Saline' 'MK801'})
subplot 212
bar_plot_with_p_publish_updated(ent_diff_med,IXS,IXM,'Entropy Post-Pre Median',true)
xticklabels({'Saline' 'MK801'})

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
