%% Filename: analyze_corr_dist.m
% Project: Corrlations > Fundamentals
% Author: Jesse Blocher
% Date: Oct 2010
% Desc: Analyzes correlation distribution for each quarter so we can
% determine a good cutoff.
% 

env; %create environment vars: home, libpath, outpath

% load matrix with dist pctls
filename = 'corr_pctiles.mat';
load(fullfile(outpath,filename), 'pctiles');
pct_header = [1 5 10 25 50 75 90 95 99];
vec_name = [num2str(pct_header'), repmat('pctl',9,1)];

%% Plot
addpath('/netscr/jabloche/matlab/util/');

time_format = 'mmm-yy';

Xyr = getTimeXAxis(1980,size(pctiles,1),'month');

tsPct = timeseries(pctiles',Xyr,'name','Correlation Matrix Percentiles');
tsPct.TimeInfo.Format = time_format;

hf1 = figure('Name','Percentile Distribution of Correlations','NumberTitle','off');
plot(tsPct);
legend(vec_name);
set(gca,'XLim',[1 11000],'YLim',[-1 1]);