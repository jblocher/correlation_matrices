addpath('/netscr/jabloche/matlab/util/');

time_format = 'mmm-yy';
load(fullfile(home,'eig_time.mat'),'eig_time');
Xyr = getTimeXAxis(1980,116);

tsEig = timeseries(eig_time(1:3,:)',Xyr,'name','Eigenvalues');
tsEig.TimeInfo.Format = time_format;

hf1 = figure('Name','Leading Eigenvalues of Quarterly Return Data','NumberTitle','off');
plot(tsEig);
legend('Leading Eigenvalue','Second Eigenvalue', 'Third Eigenvalue');
set(gca,'XLim',[1 11000]);
