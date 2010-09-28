%% Filename: index_mat_names.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Dec 2009
% Revised: Sept 2010
% 
% create index of matrix names to easily allow for jobarray processing
% Revision: Only for Correlation Matrices so no need for standardization.


env;
yr = 1980:2008;
qtr = 1:4; 
tot = length(yr)*length(qtr);

yrlist = repmat(yr,1,4);
sorted_yrlist = sort(yrlist);
qtrlist = repmat(qtr,1,length(yr));

%CRSP only through 2008 right now
stryrnlist = num2str(sorted_yrlist');
strqtrnlst = strjust(num2str(qtrlist'),'left');
zerolist = num2str(zeros(tot,1));

%these are the input matrices from SAS
retname = 'yrqtr';
retlist = repmat(retname,tot,1);

disp('Display the name lists created');
% semicolons removed to show lists
% CRSP return data
ret_name = strcat(retlist,stryrnlist,zerolist,strqtrnlst)

%home is the local code directory
filename = 'ret_name.mat';
save(fullfile(home,filename), 'ret_name');
clear all;
