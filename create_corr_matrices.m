%% Filename: create_corr_matrices.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Nov 2009
% Desc: Takes Cusip by Ret matrix from SAS (converted to MAT) and creates a
% cusip by cusip correlation matrix
% 
%RHO = corr(X) returns a p-by-p matrix containing the pairwise linear 
%       correlation coefficient between each pair of columns in the 
%       n-by-p matrix X

display('Begin Correlation Matrix Creation');  
tic; %start script timer.
env; %create environment vars: home, libpath, outpath

%Uncomment for jobarray

if isunix
    index = str2num(getenv('LSB_JOBINDEX'));
else
    index = 1; %windows
end;


%% === for testing

%index = 3;
%twomode_retmat = rand(40,100);

%===

%%
disp('Reading file');
filename = 'ret_name.mat';
varnamelist = load(fullfile(home,filename));
matname = strcat(varnamelist.ret_name,'.mat');
%%
var = load(fullfile(libpath,strtrim(matname(index,:))));
clear varnamelist filename;
%drop first column which is just dates (in SAS numeric form)
twomode_retmat = var.data(:,2:end);
clear var;

%note: we don't replace NaN here because Corr deals with NaN. We do it
%after.



s_twomode_retmat = sparse(twomode_retmat);
clear twomode_retmat;
%%

disp('Data Loaded. Computing Correlation Matrix');
[ret_corr] = corr(s_twomode_retmat);
disp(ret_corr(1:10,1:10));
clear s_twomode_retmat;

ret_corr(isnan(ret_corr)) = 0;
s_ret_corr = sparse(ret_corr);
clear ret_corr;

disp('saving correlation matrix');
%libpath is data directory in env.m
%comment this to test
filename = strcat('corr_',strtrim(matname(index,:)));
save(fullfile(libpath,filename),'s_ret_corr', '-v7.3');


%% Correlation Stats
disp('computing % negative and density');
tot_neg = sum(sum(s_ret_corr < 0));
dens_neg = tot_neg/(size(s_ret_corr,1)*size(s_ret_corr,2));
tot_kept = sum(sum(s_ret_corr ~= 0));
dens_kept = tot_kept/(size(s_ret_corr,1)*size(s_ret_corr,2));

corr_stats = full([dens_neg dens_kept ]);
filename = ['corr_stats',num2str(index),'.mat'];
save(fullfile(outpath,filename), 'corr_stats');

clear s_ret_corr;
%%
t1 = toc;
disp(elapsed(t1));
