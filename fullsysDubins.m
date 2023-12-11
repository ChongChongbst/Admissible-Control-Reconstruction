function full = fullsysDubins(compMethod, uMode)
%% Grid
grid_min = [-2; -2; -pi]; % Lower corner of computation domain
grid_max = [2; 2; pi];    % Upper corner of computation domain
N = [160; 160; 80];         % Number of grid points per dimension
pdDims = 3;               % 3rd dimension is periodic
g = createGrid(grid_min, grid_max, N, pdDims);
%% target set
R = 1;
% data = shapeRectangleByCorners(grid, lower, upper)
% data = shapeRectangleByCorners(g, [-R; -R; -pi], [R; R; pi]);
data = shapeCylinder(g, 3, [0,0], R);
%% time vector
t0 = 0;
tMax = 0.5;
dt = 0.01 ;
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
% obj = DubinsCar(x, wMax, speed, dMax)
dCar = DubinsFullCar([0,0,0], wMax, speed); %do dStep3 here

% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = dCar;
schemeData.accuracy = 'high'; %set accuracy
schemeData.uMode = uMode;
%do dStep4 here
%% Compute value function

%HJIextraArgs.visualize = true; %show plot
% HJIextraArgs.makeVideo = true; %make a video

HJIextraArgs.visualize.xTitle = '-2 < x < 2';
HJIextraArgs.visualize.yTitle = '-2 < y < 2';
HJIextraArgs.visualize.zTitle = "-\pi<\theta<\pi";

HJIextraArgs.visualize.valueSet = 1;
HJIextraArgs.visualize.initialValueSet = 1;
% HJIextraArgs.visualize.figNum = 3; %set figure number
HJIextraArgs.visualize.deleteLastPlot = true; %delete previous plot as you update

% uncomment if you want to see a 2D slice
%HJIextraArgs.visualize.plotData.plotDims = [1 1 0]; %plot x, y
%HJIextraArgs.visualize.plotData.projpt = [0]; %project at theta = 0
%HJIextraArgs.visualize.viewAngle = [0,90]; % view 2D

%[data, tau, extraOuts] = ...
% HJIPDE_solve(data0, tau, schemeData, minWith, extraArgs)
% title('BRS computation for Dubins Car')
% xlabel('-1<x<1')
% ylabel('-1<y<1')
% zlabel('-\pi<\theta<\pi')

[data_full, tau2, extra] = ...
  HJIPDE_solve(data, tau, schemeData, compMethod, HJIextraArgs);



%% Real fullsystem
full.part = data_full;
full.tau = tau;
full.g = g;
full.admiss = extra;
full.dynSys = dCar;