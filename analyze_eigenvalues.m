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

Xyr = getTimeXAxis(1980,size(eig_time,2),'month');

tsEig = timeseries(eig_time(1:3,:)',Xyr,'name','One Through Three Eigenvalues');
tsEig.TimeInfo.Format = time_format;

hf1 = figure('Name','Three Leading Eigenvalues of Monthly Return Data','NumberTitle','off');
plot(tsEig);
legend('Leading Eigenvalue','Second Eigenvalue', 'Third Eigenvalue');
set(gca,'XLim',[1 11000]);

tsEig2 = timeseries(eig_time(2:5,:)',Xyr,'name','Two Through Five Eigenvalues');
tsEig2.TimeInfo.Format = time_format;

hf2 = figure('Name','Eigenvalues 2-5 of Monthly Return Data','NumberTitle','off');
plot(tsEig2);
legend('Second Eigenvalue', 'Third Eigenvalue','Fouth Eigenvalue', 'Fifth Eigenvalue');
set(gca,'XLim',[1 11000]);


%% Ratios

den = repmat(eig_time(2,:), 8, 1);
num = eig_time(3:10,:);

eig_ratios = num./den;
%plot(eig_ratios');

tsEigR = timeseries(eig_ratios',Xyr,'name','Eigenvalue Ratios');
tsEigR.TimeInfo.Format = time_format;

hf3 = figure('Name','Ratio of Eigenvalues 3 through 9 divided by Second','NumberTitle','off');
plot(tsEigR);
legend( '3rd Eigenvalue', '4th Eigenvalue',...
        '5th Eigenvalue','6th Eigenvalue', '7th Eigenvalue',...
        '8th Eigenvalue','9th Eigenvalue', '10th Eigenvalue');
set(gca,'XLim',[1 11000]);

%%
%hf4 = figure('Name','Scatterplot of first and second eigenvalues','NumberTitle','off');
%scatter(eig_time(1,:)',eig_time(2,:)');
%set(gca,'XLim',[0.01 0.1]);
%set(gca,'YLim',[0.01 0.1]);


