% env.m
% sets environment variables for this environment. Includes:
%   - Paths to other third party packages
%   - sets libpath, home, outpath variables for loading and saving
% J Blocher December 2009


% Matlab Libraries
addpath('/netscr/jabloche/matlab/util/mit_matlab_functions/');
addpath('/netscr/jabloche/matlab/util/');
addpath('/netscr/jabloche/matlab/util/contest/');
addpath('/netscr/jabloche/matlab/util/network/');
addpath('/netscr/jabloche/matlab/util/Louvain/');
addpath('/netscr/jabloche/matlab/util/matlab_bgl/');

% Local paths and data locations
global libpath home outpath
libpath = '/largefs/jabloche/fn_mat/';
home = '/netscr/jabloche/Correlations/';
outpath = '/largefs/jabloche/fn_out/';