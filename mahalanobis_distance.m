%% Filename: mahalanobis_distance.m
% Project: Corr > Fund
% Author: Jesse Blocher
% Date: Oct 2010
% Desc: test to see if this is a good measure of 'detachment' of indexation
% 
env;
% test
index = 1;

%% this has the eigenvalues and eigenvectors
filename = ['ret_eigs',num2str(index),'.mat'];
load(fullfile(outpath,filename));
corr = V*S*S*V';

snp_example = corr(1:500,1:500);

%% this is the raw data
% load matrix with check dimensions
load(fullfile(libpath,'cusip_stats.mat'));
corrmat_stats = data;
clear data;

disp(['Reading file for index: ',num2str(index)]);
filename = ['yrqtr_new',num2str(corrmat_stats(index,1)),'0',num2str(corrmat_stats(index,2)),'.mat'];
load(fullfile(libpath,filename));
A = data;
clear data;

%check for nonexistent data (quarters have varying numbers of trading days)
last_day = find(sum(isnan(A),1) == size(A,1),1) - 1;
if last_day < size(A,2) %this works because if the right size, last_day is empty and skips this.
    A = A(:,1:last_day);
end;

if max(abs(size(A)-corrmat_stats(index,3:4))) ~= 0
    disp(['Matrix Sizes do not match for index: ', num2str(index)]);
    disp(size(A));
    disp(corrmat_stats(index,3:4));
    warning(['Index: ', num2str(index)]);
end
% need to figure out what to do about missing values.
% set NaN (missing) to 0. Not sure what I think about this.

A(isnan(A)) = 0;