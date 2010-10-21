%% Filename: corrmat_edgelists.m
% Project: Corrlations > Fundamentals
% Author: Jesse Blocher
% Date: Oct 2010
% Desc: Reads and outputs corr matrices as edgelists
% 

display('Begin');  
tic; %start script timer.
env; %create environment vars: home, libpath, outpath

% load matrix with check dimensions
load(fullfile(libpath,'cusip_stats_yrmo.mat'));
corrmat_stats = data;
clear data;

filename = ['corr_pctiles.mat'];
load(fullfile(outpath,filename), 'pctiles');

num_pd = size(corrmat_stats,1);

for index=1:num_pd
    disp(['Reading file for index: ',num2str(index)]);
    filename = ['ret_eigs',num2str(index),'.mat'];
    load(fullfile(outpath,filename), 'S','V');
    corr = V*S*S*V';
    
    %set those less than 90th pctile equal to zero;
    corr(corr < pctiles(index,7)) = 0;
    
    [i, j, w] = find(corr);
    t = repmat([index corrmat_stats(index,1) corrmat_stats(index,2)],length(i),1);
    el = [i j w t]; 
    filename = ['corr_el_',num2str(corrmat_stats(index,1)),'0',num2str(corrmat_stats(index,2)),'.mat'];
    save(fullfile(libpath,filename), 'el');

end
clear S V index i j w t num_pd filename;


t1 = toc;
disp(elapsed(t1));