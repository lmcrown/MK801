function PhaAmpCoup(s, Fs, csc_n)
% calculate and plot the Phase Amplitude coupling
%% get the input of time period
gx_t_str=inputdlg({'analyze signal starts from (unit:s)(default is 0)','analyze signal ends at (unit:s) (no default value)'}, 'Phase Amplitude Coupling:input');

if isempty(gx_t_str{1})
    gx_t(1)=0;
else
    gx_t(1)=str2num(gx_t_str{1});
end

if isempty(gx_t_str{2})
    error('no input for end time.');
else
    gx_t(2)=str2num(gx_t_str{2});
end

if gx_t(1)>=gx_t(2)
    error('starting time has to be smaller than ending time');
end

%% organize input data
s = squeeze(s);
if ndims(s) > 2
    error('first arg must be either matrix or squeezable to matrix')
end
if isvector(s)
    data = s(:);
end

% frequency range and the step size during calculation
fp=[3 17]; 
dfp=2; % step size
fa=[40 200];
dfa=40; % step size

axis_fp=fp(1):dfp:fp(end);
axis_fa=fa(1):dfa:fa(end);
PhaAmpCoup_MI=zeros(length(axis_fa),length(axis_fp)); % create space for output

bin=20;       % bin in phase angel   
N=360/bin;

fn=128;  % order of filter
xind=0;
yind=0;
for f_p=fp(1):dfp:(fp(end)-dfp)
    xind=xind+1;
    for f_a=fa(1):dfa:(fa(end)-dfa)
        yind=yind+1;
        bp=fir1(fn,[f_p/(Fs/2) (f_p+dfp)/(Fs/2)]);
        ba=fir1(fn,[f_a/(Fs/2) (f_a+dfa)/(Fs/2)]);
        xfp=filtfilt(bp,1,data);            % 2 mean filter along each line
        xfa=filtfilt(ba,1,data);  

        pha=angle(hilbert(xfp))./pi.*180;  % -180:180
        pha(pha<0)=pha(pha<0)+360;         % 0:360
        amp=abs(hilbert(xfa));

        avg_A=zeros(N,1);
        for j=1:N
            t_temp=find(pha>=(bin*(j-1)) & pha< (bin*j));
            avg_A(j)=sum(amp(t_temp))./length(t_temp);
            clear t_temp
        end
        pA=avg_A./sum(avg_A);
        H_A=-sum(pA.*log(pA));
        PhaAmpCoup_MI(yind,xind)=(log(N)-H_A)./log(N);
    end
end
figure,
imagesc(fp,fa,PhaAmpCoup_MI);
xlabel('Phase freqeuncy');
ylabel('Amplitude frequency');
title('Phase Amplitude Coupling');
colormap(jet);
set(gca,'YDir','normal')
figname=['Phase Amplitude Coupling ',num2str(csc_n),'.fig'];
matname=['Phase Amplitude Coupling ',num2str(csc_n),'.mat'];
saveas(gcf,figname);
save(matname,'PhaAmpCoup_MI');
end
    
    
  