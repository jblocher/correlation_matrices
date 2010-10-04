%% Filename: analyze_eigenvectors.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Oct 2010
% Desc: not sure yet. Look at the eigenvectors.
% 

display('Begin Analyze Eigenvectors');  
tic; %start script timer.
env; %create environment vars: home, libpath, outpath

num_qtr = 116;
num_assets = 24489;

eig_vec = zeros(num_qtr,num_assets);
keep_vec = zeros(num_qtr,num_assets);
used_assets = zeros(num_qtr,1);
for index=1:num_qtr
    disp(['Reading file for index: ',num2str(index)]);
    filename = ['ret_eigs',num2str(index),'.mat'];
    load(fullfile(outpath,filename), 'S','V', 'keep_securities');
    %get leading eigenvector
    eig_vec(index,keep_securities) = V(:,1);
    keep_vec(index,keep_securities) = 1;
    used_assets(index) = length(keep_securities);
end
clear S V keep_securities index;

keep_assets = sum(abs(keep_vec),1);
drop_assets = find(keep_assets == 0);


t1 = toc;
disp(elapsed(t1));
