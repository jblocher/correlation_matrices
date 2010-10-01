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

num_qtr = 116;

num_eig = 10;
eig_time = zeros(num_eig,num_qtr);

% testing
for index = 1:num_qtr;

disp(['Reading file for index: ',num2str(index)]);
filename = 'ret_name.mat';
varnamelist = load(fullfile(home,filename));
matname = strcat(varnamelist.ret_name,'.mat');
%%
var = load(fullfile(libpath,strtrim(matname(index,:))));
clear varnamelist filename;
%drop first column which is just dates (in SAS numeric form)
twomode_retmat = var.data(:,2:end)';
clear var;

% need to figure out what to do about missing values.

%% set NaN (missing) to 0. Not sure what I think about this.
checkvec = nansum(twomode_retmat,2);
keep_securities = find(checkvec ~= 0); %need to save this vector, it is the list of securities we're keeping
clear checkvec;
active_retmat = twomode_retmat(keep_securities,:);

active_retmat(isnan(active_retmat)) = 0;
%clear twomode_retmat;

[S V] = quickCorr(active_retmat');
D = diag(S)/sum(diag(S)); %normalized eigenvalues
eig_time(:,index) = D(1:num_eig);

filename = ['ret_eigs',num2str(index),'.mat'];
save(fullfile(outpath,filename), 'S','V', 'keep_securities');
end;

clear index S V D active_retmat;
save(fullfile(home,'eig_time.mat'),'eig_time');

t1 = toc;
disp(elapsed(t1));
