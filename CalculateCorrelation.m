%% Gengxi Lu 12/19/2019
function CalculateCorrelation(CSCdata, ChosenCSCs)
%% get the input of time period
gx_t_str=inputdlg({'analyze signal starts from (unit:s)(default is 0)','analyze signal ends at (unit:s) (no default value)'}, 'Correlation');

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

%% organize data and cut it based on input
gx_n=numel(ChosenCSCs(:));
for csc_i = 1:gx_n
      temp = squeeze(CSCdata(ChosenCSCs(csc_i)).DataArray(:));
      gx_s.f(csc_i)= CSCdata(ChosenCSCs(csc_i)).Fs;
      if ndims(temp) > 2
          % error('first arg must be either matrix or squeezable to matrix');
          error(['input data error at',num2str(scs_i),'th input from Gengxi']);
      end
      if isvector(temp)
          gx_s.data{csc_i} = temp(:); % use cell array in case the data have different length
      end
end
% check if all the sampling freqeuncy are same. To ensure the later data can
% have same length.
if ~all(gx_s.f==gx_s.f(1))
    error('inputs have different sampling frequency from Gengxi');
end

% determine the start point (sp) and the end point (ep)
gx_dt=1/gx_s.f(1);
gx_sp=(gx_t(1)/gx_dt)+1;
gx_ep=(gx_t(2)/gx_dt);
gx_s_cut=zeros(gx_ep-gx_sp+1,gx_n);

for i=1:gx_n
    gx_s_cut(:,i)=gx_s.data{i}(gx_sp:gx_ep);
end

%% calculation
% calculate the correlation coefficient and the pvalue for testing the
% hypothesis that there is no relationship. When P is smaller than 0.05, it
% is considered as have relationship.
[gx_corcoef, gx_cor_pval]=corrcoef(gx_s_cut);
% plot figure
figure,
imagesc(gx_corcoef);
title('corcoef');
saveas(gcf,'corcoef.fig');
save('corcoef.mat','gx_corcoef');
end
