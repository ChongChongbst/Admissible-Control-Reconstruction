function decomposed = decomposition(compMethod, uMode)
% Dubins Car Example
% 1. compute the BRS for separate element
% 2. combine the BRS

%% The Separated Grid
grid_min = [-2; -pi]; % Lower corner of computation domain
grid_max = [2; pi];    % Upper corner of computation domain
N = [160; 80];         % Number of grid points per dimension
pdDims = 2;               % 2nd dimension is periodic
g = createGrid(grid_min, grid_max, N, pdDims);
% Use "g = createGrid(grid_min, grid_max, N);" if there are no periodic
% state space dimensions
%% target set
R = 1;
% data = shapeRectangleByCorners(grid, lower, upper)
data1 = shapeRectangleByCorners(g, [-R; -pi], [R; pi]);
data2 = shapeRectangleByCorners(g, [-R; -pi], [R; pi]);

%% time vector
t0 = 0;
tMax = 0.5;
dt = 0.01;
tau = t0:dt:tMax;

%% problem parameters

% input bounds
speed = 1;
wMax = 1;
% do dStep1 here

% control trying to min or max value function?
% do dStep2 here

%% Pack problem parameters

% Define dynamic system
% obj = sys1(x, wMax, speed, dMax, dims)
dsys1 = sys1([0, 0], wMax, speed); %do dStep3 here
% Put grid and dynamic systems into schemeData
schemeData1.grid = g;
schemeData1.dynSys = dsys1;
schemeData1.accuracy = 'high'; %set accuracy
schemeData1.uMode = uMode;
%do dStep4 here

%% Pack problem parameters

% Define dynamic system
% obj = sys1(x, wMax, speed, dMax, dims)
dsys2 = sys2([0, 0], wMax, speed); %do dStep3 here
% Put grid and dynamic systems into schemeData
schemeData2.grid = g;
schemeData2.dynSys = dsys2;
schemeData2.accuracy = 'high'; %set accuracy
schemeData2.uMode = uMode;
%do dStep4 here
%% Compute value function
% 
% HJIextraArgs_1.visualize = true; %show plot
HJIextraArgs_1.visualize.initialValueSet = 1;
HJIextraArgs_1.visualize.valueFunction = 1;
HJIextraArgs_1.visualize.figNum = 1; %set figure number
HJIextraArgs_1.visualize.deleteLastPlot = true; %delete previous plot as you update
HJIextraArgs_1.visualize.viewAngle = [45, 45]; 
HJIextraArgs_1.visualize.xTitle = '-2 < x < 2';
HJIextraArgs_1.visualize.yTitle = '-\pi<\theta<\pi';
HJIextraArgs_1.visualize.zTitle = "V(x,\theta,t)";
HJIextraArgs_1.makeVideo = false;
HJIextraArgs_1.visualize.valueSet = true;

% HJIextraArgs_2.visualize = true; %show plot
HJIextraArgs_2.visualize.valueSet = true;
HJIextraArgs_2.visualize.initialValueSet = 1;
HJIextraArgs_2.visualize.figNum = 2; %set figure number
HJIextraArgs_2.visualize.deleteLastPlot = true; %delete previous plot as you update
HJIextraArgs_2.visualize.xTitle = '-2 < y < 2';
HJIextraArgs_2.visualize.yTitle = '-\pi<\theta<\pi';
HJIextraArgs_2.makeVideo = false;
% uncomment if you want to see a 2D slice
%HJIextraArgs.visualize.plotData.plotDims = [1 1 0]; %plot x, y
%HJIextraArgs.visualize.plotData.projpt = [0]; %project at theta = 0
%HJIextraArgs.visualize.viewAngle = [0,90]; % view 2D

%[data, tau, extraOuts] = ...
% HJIPDE_solve(data0, tau, schemeData, minWith, extraArgs)
[data_1, tau2_1, extra1] = ...
  HJIPDE_admis_solve(data1, tau, schemeData1, compMethod, HJIextraArgs_1);

[data_2, tau2_2, extra2] = ...
  HJIPDE_admis_solve(data2, tau, schemeData2, compMethod, HJIextraArgs_2);
% [data_2, tau2_2, ~] = ...
%   HJIPDE_admis_solve(data2, tau, schemeData2, 'set', HJIextraArgs_2);
%% Two subsystems
decomposed.part1.data = data_1;
decomposed.part2.data = data_2;
decomposed.part1.admiss = extra1;
decomposed.part2.admiss = extra2;
decomposed.part1.dynSys1 = dsys1;
decomposed.part2.dynSys2 = dsys2;
decomposed.g = g;
decomposed.tau = tau;


