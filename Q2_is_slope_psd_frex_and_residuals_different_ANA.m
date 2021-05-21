% Q2_is_slope_psd_frex_and_residuals_different_ANA


clear all
ANA_dir='F:\Keck Medicine of USC\MK801_Results\Chronic\Q2_is_slope_psd_frex_and_residuals_different';

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
    if strfind(Dset.day,'PSD')==1
        day(ses_cnt)= str2double(Dset.day(end));
    else day(ses_cnt)=str2double(Dset.day(end-1:end));
    end
    %       day_num(ses_cnt)=str2double(Dset.ses.name(end-1:end));
    pxx_no_art(ses_cnt,:)=Dset.pxx_noart;
    thetafrex(ses_cnt,:)=Dset.thetafreq;
    lowgammafrex(ses_cnt,:)=Dset.lowgammafrex;
    highgammafrex(ses_cnt,:)=Dset.highgammafrex;
    slope(ses_cnt,:)=Dset.slope;
    resid(ses_cnt,:)= Dset.resid;
    
    
    ses_cnt = ses_cnt + 1;
end
frex=2:0.5:120; %change later to update with fnction

group=categorical(group);
% animal= categorical(animal);

SIX=group=='SALIN';
MIX=group=='MK801';
[an,ix]=unique(animal);
grp=group(ix);

IXS= grp== 'SALIN';
IXM= grp== 'MK801';

[an,ix]=unique(animal);
BIX=frex>59.5 &frex<60.5;
pxx_no_art(:,BIX)=mean([pxx_no_art(:,frex==59) pxx_no_art(:,frex==61)],2);
%%
for iani=1:length(an)
    ANIX=animal==an(iani);
    numplots= sum(ANIX);
    dayz=day(ANIX);
    an_pxxs=pxx_no_art(ANIX,:);
    [daynums,i]=sort(dayz);
    sortedpxx=an_pxxs(i,:);
    
    figure
    for iday=1:length(daynums)
        subplot(numplots,1,iday)
        plot(frex,10*log10(sortedpxx(iday,:)))
        title(sprintf('Rat %i Day %i %s',an(iani),daynums(iday),grp(iani)))
    end
    equalize_y_axes
end

%% How does the slope change?  

figure
dayz=unique(day);
for iday=1:length(dayz)
DIX=day==dayz(iday);
subplot(2,ceil(length(dayz)/2),iday)
bar_plot_with_p_publish_updated(slope,DIX & SIX, DIX & MIX,sprintf('Day %i',dayz(iday)))
xticklabels({'Saline' 'MK801'})
end
equalize_y_axes
% realisticially this needs to be a repeatd measures anova 

%% PLOT pre and post for saline and MK801
% figure;
% subplot 211
% plot_confidence_intervals(frex,10*log10(pxx_no_art(SIX & PREIX,:)),[],[0 0 1])
% hold on
% plot_confidence_intervals(frex,10*log10(pxx_no_art(MIX &PREIX ,:)),[],[1 0 0])
% title('PRE')
% subplot 212
% plot_confidence_intervals(frex,10*log10(pxx_no_art(SIX &POSTIX,:)),[],[0 0 1])
% hold on
% plot_confidence_intervals(frex,10*log10(pxx_no_art(MIX &POSTIX,:)),[],[1 0 0])
% title('POST')
equalize_axes
%% animal level differences
% figure;
% plot_confidence_intervals(frex,difference(IXS,:),[],[0 0 1])
% hold on
% plot_confidence_intervals(frex,difference(IXM ,:),[],[1 0 0])
% title('Post-Pre / Post + Pre')

%% LOOK at just the post time periods for PSD8 and make comparisons between groups
for iani=1:length(an)
    ANIX=animal==an(iani);
   numplots= sum(ANIX);
   dayz=day(ANIX);
   an_pxxs=pxx_no_art(ANIX,:);
   ans_theta=thetafrex(ANIX);
   [daynums,i]=sort(dayz);
   sortedpxx=an_pxxs(i,:);
  sortedtheta= ans_theta(i);
       figure
%        for iday=1:length(daynums)
plot(daynums,sortedtheta,'ok')
[r,p]=corrcoef(daynums,sortedtheta,'Rows','pairwise')
r_theta(iani,:)=r(1,2);
p_theta(iani,:)=p(1,2);

       title(sprintf('Rat %i %s p= %2.2f',an(iani),grp(iani),p_theta(iani)))
%        end
end
%% Gamma- Low
for iani=1:length(an)
    ANIX=animal==an(iani);
   numplots= sum(ANIX);
   dayz=day(ANIX);
   an_pxxs=pxx_no_art(ANIX,:);
   ans_lg=lowgammafrex(ANIX);
   [daynums,i]=sort(dayz);
   sortedpxx=an_pxxs(i,:);
  sortedlg= ans_lg(i);
       figure
%        for iday=1:length(daynums)
plot(daynums,sortedlg,'ok')
[r,p]=corrcoef(daynums,sortedlg,'Rows','pairwise')
r_lg(iani,:)=r(1,2);
p_lg(iani,:)=p(1,2);

       title(sprintf('Rat %i %s p= %2.2f',an(iani),grp(iani),p_lg(iani)))
%        end
end

