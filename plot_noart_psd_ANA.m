% plot_noart_psd_ANA

%Q2_Gamma_power_Ratio_across_trial

%Based on Q7_Does_Ratio_HighvLow_change_wleadup_to_stim_6_ANA
% ANA_dir='E:\Lindsey\Lesley_Data\Analysis\Lesley_data\Q7_Does_Ratio_HighvLow_change_wleadup_to_stim_6';
clear all
ANA_dir='F:\Keck Medicine of USC\MK801_Results\Acute\plot_noart_psd\mPFC\PSD7';

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
  pxx_no_art(ses_cnt,:)=Dset.pxx_noart;
 pxx(ses_cnt,:)=Dset.pxx;
 thetafrex(ses_cnt,:)=Dset.thetafreq;
 lowgammafrex(ses_cnt,:)=Dset.lowgammafrex;
 highgammafrex(ses_cnt,:)=Dset.highgammafrex;
   
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

[an,ix]=unique(animal);
BIX=frex>59.5 &frex<60.5;
difference=nan(length(an),length(frex));
% diff=nan(length(an),length(frex));
for iani=1:length(an) % MAYBE MAKE A ZSCORE?
    ANIX=animal==an(iani);
    if sum(ANIX &PREIX) + sum(ANIX &POSTIX)~=2
        difference(iani,:)=nan(1,length(frex));
    else
        difference(iani,:)=(pxx_no_art(ANIX & POSTIX,:)-pxx_no_art(ANIX & PREIX,:))./(pxx_no_art(ANIX & PREIX,:)+pxx_no_art(ANIX & POSTIX,:));
        difference(iani,BIX)=nan;
    end
end
%%
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
