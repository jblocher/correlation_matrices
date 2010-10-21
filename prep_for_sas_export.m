%% Filename: prep_for_sas_export.m
% Project: Corrlations > Fundamentals
% Author: Jesse Blocher
% Date: Oct 2010
% Desc: Preps the matlab data to go back to SAS. Note Stattransfer doesn't
% accept Matlab text fields, so we write our CUSIP file as text.
% 

display('Begin Prep for SAS');  
tic; %start script timer.
env; %create environment vars: home, libpath, outpath

% load matrix with check dimensions
load(fullfile(libpath,'cusip_stats_yrmo.mat'));
corrmat_stats = data;
clear data;

num_pd = size(corrmat_stats,1);
num_assets = max(corrmat_stats(:,3));


for index=1:num_pd
    disp(['Reading file for index: ',num2str(index)]);
    filename = ['ret_eigs',num2str(index),'.mat'];
    load(fullfile(outpath,filename), 'S','V');
    
    year = repmat(corrmat_stats(index,1),1,corrmat_stats(index,3));
    qtr = repmat(corrmat_stats(index,2),1,corrmat_stats(index,3));
    
    sasdata = [year' qtr' V(:,1:4)];
    
    filename = ['foureig_sas_monthly',num2str(index),'.mat'];
    save(fullfile(outpath,filename), 'sasdata');
end
clear S V index;


t1 = toc;
disp(elapsed(t1));
