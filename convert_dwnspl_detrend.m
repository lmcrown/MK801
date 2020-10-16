function [LFP,sFreq]=convert_dwnspl_detrend(csc,desired_Fs)

if nargin<2
    desired_Fs=1000;
end
[LFP,~,Fs] = nlx2matCSC_Matrix(csc);
% [a,b]=Read_nlx_CR_files({csc},[])
sFreq=desired_Fs;

nrecs=length(LFP);
totalsecs=nrecs/Fs;
% test_LFP= INTAN_Read_DAT_file(amps{1}, decimation_factor);

newLFP = resample(LFP(:,2),sFreq,Fs);

srate=length(newLFP)/totalsecs;
assert(isequal(round(srate),sFreq),'Time Stamps are wrong')

time=linspace(0,totalsecs,length(newLFP))'; %time will now be in seconds

clear LFP
LFP=[time,newLFP];
clear newLFP
LFP(:,2) = LFP(:,2) - movmedian( LFP(:,2), sFreq*2); %detrend