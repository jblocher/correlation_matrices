%% Filename: svd_corr.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Oct 2010
% Desc: Uses SVD to get eigenvalues and eigenvectors by which we can easily
% compute correlation matrix later if needed. Much faster and easier.
% 

display('Begin SVD');  
tic; %start script timer.
env; %create environment vars: home, libpath, outpath

num_qtr = 120;

% load matrix with check dimensions
load(fullfile(libpath,'cusip_stats.mat'));
corrmat_stats = data;
clear data;

num_eig = 10;
eig_time = zeros(num_eig,num_qtr);

% testing
for index = 1:num_qtr;

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

%% set NaN (missing) to 0. Not sure what I think about this.

A(isnan(A)) = 0;

%corr is on columns of A, so need transpose of what we have to get cusip by
%cusip cov matrix
% corr(A) = V*S*S'*V';
[S V] = quickCorr(A');
D = diag(S)/sum(diag(S)); %normalized eigenvalues
eig_time(:,index) = D(1:num_eig);

filename = ['ret_eigs',num2str(index),'.mat'];
save(fullfile(outpath,filename), 'S','V');
end;

clear index S V D;
save(fullfile(home,'eig_time.mat'),'eig_time');

t1 = toc;
disp(elapsed(t1));
