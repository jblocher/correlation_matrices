%% Filename: correlation_dist_cutoff.m
% Project: Corrlations > Fundamentals
% Author: Jesse Blocher
% Date: Oct 2010
% Desc: Computes correlation distribution for each quarter so we can
% determine a good cutoff.
% 

display('Begin');  
tic; %start script timer.
env; %create environment vars: home, libpath, outpath

% load matrix with check dimensions
load(fullfile(libpath,'cusip_stats_yrmo.mat'));
corrmat_stats = data;
clear data;

num_pd = size(corrmat_stats,1);


pct_header = [1 5 10 25 50 75 90 95 99];
pctiles = zeros(num_pd,length(pct_header));

%test
%index = 1;

for index=1:num_pd
    disp(['Reading file for index: ',num2str(index)]);
    filename = ['ret_eigs',num2str(index),'.mat'];
    load(fullfile(outpath,filename), 'S','V');
    corr = V*S*S*V';
    corr(corr == triu(corr)) = NaN; %sets diagonal and duplicates to NaN
    
    corr_vec = reshape(corr,1,size(corr,1)^2);
    corr_vec = corr_vec(~isnan(corr_vec)); %only keep those that are NOT NaN
    
    pctiles(index,:) = prctile(corr_vec,pct_header);
    

end
clear S V index;

filename = ['corr_pctiles.mat'];
save(fullfile(outpath,filename), 'pctiles');

t1 = toc;
disp(elapsed(t1));