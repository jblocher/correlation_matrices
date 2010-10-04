%% Filename: analyze_eigenvalues.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Oct 2010
% Desc: not sure yet. Look at the eigenvalues.
% 
%% import data
load(fullfile(home,'eig_time.mat'),'eig_time');

%% Plot
addpath('/netscr/jabloche/matlab/util/');

time_format = 'mmm-yy';

Xyr = getTimeXAxis(1980,116);

tsEig = timeseries(eig_time(1:3,:)',Xyr,'name','Eigenvalues');
tsEig.TimeInfo.Format = time_format;

hf2 = figure('Name','Leading Eigenvalues of Quarterly Return Data','NumberTitle','off');
plot(tsEig);
legend('Leading Eigenvalue','Second Eigenvalue', 'Third Eigenvalue');
set(gca,'XLim',[1 11000]);

%% Ratios

den = repmat(eig_time(1,:), 9, 1);
num = eig_time(2:10,:);

eig_ratios = num./den;
%plot(eig_ratios');

tsEigR = timeseries(eig_ratios',Xyr,'name','Eigenvalue Ratios');
tsEigR.TimeInfo.Format = time_format;

hf1 = figure('Name','Ratio of Eigenvalues 2 through 9 divided by Leading','NumberTitle','off');
plot(tsEigR);
legend( '2nd Eigenvalue','3rd Eigenvalue', '4th Eigenvalue',...
        '5th Eigenvalue','6th Eigenvalue', '7th Eigenvalue',...
        '8th Eigenvalue','9th Eigenvalue', '10th Eigenvalue');
set(gca,'XLim',[1 11000]);

%%
scatter(eig_time(1,:)',eig_time(2,:)');
set(gca,'XLim',[0.01 0.1]);
set(gca,'YLim',[0.01 0.1]);


