%% Filename: investigate_corr_matrices.m
% Project: Something with Correlations
% Author: Jesse Blocher
% Date: Sept 2010
% Desc: Various commands investigating structure of correlation matrices
% 

env; %create environment variables
%% Load data
display('Reading Correlation Matrix'); 
name = 'corr_yrqtr198001.mat';
data = load(fullfile(libpath,name));

s_ret_corr = data.s_ret_corr;
clear data;
%load(fullfile(outpath,'corr_stats1.mat'),'-mat','corr_stats');

%% Pare it down
rowsum = sum(s_ret_corr);
ind = find(rowsum);
maxind = max(ind);

sm_corrmat = s_ret_corr(1:maxind,1:maxind);
clear rowsum maxind ind s_ret_corr;

%% some real stats
%{
display('Real Matrix Statistics'); 
tot_neg = sum(sum(sm_corrmat < 0));
dens_neg = tot_neg/(size(sm_corrmat,1)*size(sm_corrmat,2));
tot_kept = sum(sum(sm_corrmat ~= 0));
dens_kept = tot_kept/(size(sm_corrmat,1)*size(sm_corrmat,2));

corr_stats2 = full([dens_neg dens_kept ]);
disp(corr_stats2);
clear tot_neg dens_neg tot_kept dens_kept;
%}

%% Now, some analysis
display('Now compute square of correlation matrix');
all_sq = sm_corrmat^2;
all_qu = sm_corrmat^4;
clear sm_corrmat;
addpath('/netscr/jabloche/matlab/util/BrainConnectivity/');

display('Reorder Matrix Squared...10000');
[MATreordered,MATindices,MATcost] = reorderMAT(all_sq,10000,'line');
filename = 'vis_corrmat_square10000.mat';
save(fullfile(outpath,filename),'MATreordered','MATindices','MATcost','-v7.3');

display('Reorder Matrix Squared...20000');
[MATreordered,MATindices,MATcost] = reorderMAT(all_sq,20000,'line');
filename = 'vis_corrmat_square20000.mat';
save(fullfile(outpath,filename),'MATreordered','MATindices','MATcost','-v7.3');

display('Reorder Matrix ^4...5000');
[MATreordered,MATindices,MATcost] = reorderMAT(all_qu,5000,'line');
filename = 'vis_corrmat_quad5000.mat';
save(fullfile(outpath,filename),'MATreordered','MATindices','MATcost','-v7.3');

display('Reorder Matrix ^4...10000');
[MATreordered,MATindices,MATcost] = reorderMAT(all_qu,10000,'line');
filename = 'vis_corrmat_quad10000.mat';
save(fullfile(outpath,filename),'MATreordered','MATindices','MATcost','-v7.3');

display('Reorder Matrix ^4...20000');
[MATreordered,MATindices,MATcost] = reorderMAT(all_qu,20000,'line');
filename = 'vis_corrmat_quad20000.mat';
save(fullfile(outpath,filename),'MATreordered','MATindices','MATcost','-v7.3');

display('Saving squared and quad matrices');
filename = 'corrmat_sq_qu.mat';
save(fullfile(outpath,filename),'all_sq','all_qu','-v7.3');
