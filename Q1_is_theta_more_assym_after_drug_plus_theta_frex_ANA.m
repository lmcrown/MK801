% plot_noart_psd_ANA

%Q2_Gamma_power_Ratio_across_trial

%Based on Q7_Does_Ratio_HighvLow_change_wleadup_to_stim_6_ANA
% ANA_dir='E:\Lindsey\Lesley_Data\Analysis\Lesley_data\Q7_Does_Ratio_HighvLow_change_wleadup_to_stim_6';
clear all
ANA_dir='F:\Keck Medicine of USC\MK801_Results\Q1_is_theta_more_assym_after_drug_plus_theta_frex\PSD7';

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
    assym(ses_cnt)=Dset.assym;
    thetfrex(ses_cnt)=Dset.theta_freq;
    
    av_theta(ses_cnt,:)=Dset.av_theta;
   
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
difference=nan(length(an), 1);
 for iani=1:length(an) 
     ANIX=animal==an(iani);
    if sum(ANIX &PREIX) + sum(ANIX &POSTIX)~=2
        difference(iani)=nan;
     else
        difference(iani,:)=(thetfrex(ANIX & POSTIX)-thetfrex(ANIX & PREIX));
     end
 end
%%
%% PLOT pre and post for saline and MK801
figure;
subplot 211
plot_confidence_intervals(1:999,av_theta(SIX & PREIX,:),[],[1 0 1])
hold on
plot_confidence_intervals(1:999,av_theta(SIX & POSTIX ,:),[],[0 1 0])
title('SALINE')
subplot 212
plot_confidence_intervals(1:999,av_theta(MIX &PREIX,:),[],[1 0 1])
hold on
plot_confidence_intervals(1:999,av_theta(MIX &POSTIX,:),[],[0 1 0])
title('MK801')
equalize_axes
%% Compare asymmmetry by numbers
figure
subplot 121
bar_plot_with_p_publish_updated(assym,SIX & PREIX,SIX & POSTIX,'SLN' )
ylabel('Assym')
xticklabels({'Saline Pre' 'Saline Post'})
subplot 122
bar_plot_with_p_publish_updated(assym,MIX & PREIX,MIX & POSTIX,'DRUG' )
xticklabels({'MK801 Pre' 'MK801 Post'})
%% Theta Freq
figure
subplot 121
bar_plot_with_p_publish_updated(thetfrex,SIX & PREIX,SIX & POSTIX,'SLN' )
ylabel('Peak Theta')
ylim([6 8])
xticklabels({'Saline Pre' 'Saline Post'})
subplot 122
bar_plot_with_p_publish_updated(thetfrex,MIX & PREIX,MIX & POSTIX,'DRUG' )
xticklabels({'MK801 Pre' 'MK801 Post'})
ylim([6 8])
%% differnce in theta freq
figure
bar_plot_with_p_publish_updated(difference,IXS,IXM,'Diff' )
ylabel('Post-Pre Freq Diff')
xticklabels({'Saline' 'MK801'})
