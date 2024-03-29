%% TEST_ALL.m
% Numerical Differentiation Toolbox
%
% Runs all unit testing scripts.
%
% Copyright © 2021 Tamas Kis
% Last Update: 2022-11-12
% Website: https://tamaskis.github.io
% Contact: tamas.a.kis@outlook.com
%
% DEPENDENCIES:
%   • Simple Unit Testing Toolbox (https://github.com/tamaskis/Simple_Unit_Testing_Toolbox-MATLAB)
%   • Numerical Differentiation Toolbox (https://www.mathworks.com/matlabcentral/fileexchange/97267-numerical-differentiation-toolbox)



%% SCRIPT SETUP

% clears Workspace and Command Window, closes all figures
clear; clc; close all;

% adds path to testing scripts
addpath('scripts')



%% RUNS ALL TESTS

TEST_complexified;
TEST_derivative;
TEST_directional;
TEST_gradient;
TEST_hessian;
TEST_jacobian;
TEST_partial;
TEST_vechessian;