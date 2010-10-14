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
load(fullfile(libpath,'cusip_stats.mat'));
corrmat_stats = data;
clear data;

num_qtr = size(corrmat_stats,1);
num_assets = max(corrmat_stats(:,3));

datev = getYrQtrInd(1980,2009);
filename = 'matlab_datevector.mat';
save(fullfile(outpath,filename), 'datev');

for index=1:num_qtr
    disp(['Reading file for index: ',num2str(index)]);
    filename = ['ret_eigs',num2str(index),'.mat'];
    load(fullfile(outpath,filename), 'S','V');
    
    year = repmat(datev(index,2),1,corrmat_stats(index,3));
    qtr = repmat(datev(index,3),1,corrmat_stats(index,3));
    
    sasdata = [year' qtr' V(:,1:4)];
    
    filename = ['foureig_sas',num2str(index),'.mat'];
    save(fullfile(outpath,filename), 'sasdata');
end
clear S V index;


t1 = toc;
disp(elapsed(t1));
