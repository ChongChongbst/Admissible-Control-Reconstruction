function [g,data_full] = local_update_1()
%% Construct smallest grid
grid_min = [-2; -2; -pi];
grid_max = [2; 2; pi];
pdDims = 3;
N = [17; 17; 41];
g = createGrid(grid_min, grid_max, N, pdDims);

R = 1;
data = shapeCylinder(g, 3, [0,0], R);

%% time vector
t0 = 0;
tMax = 0.8;
dt = 0.01;
tau = t0:dt:tMax;

%% Indexes for updating region
% index = find(g.xs{1,1}<=-0.6)|find(g.xs{1,1}>=0.6)|find(g.xs{2,1}<=-0.6)|find(g.xs{2,1}>=0.6);
% schemeData.index = index;

%% Car system
speed = 1;
wMax = 1;
dCar = DubinsFullCar([0,0,0], wMax, speed);

schemeData.grid = g;
schemeData.dynSys = dCar;
schemeData.accuracy = 'high'; %set accuracy
schemeData.uMode = 'min';

%% Compute value function

%HJIextraArgs.visualize = true; %show plot
% HJIextraArgs.makeVideo = true; %make a video

HJIextraArgs.visualize.xTitle = '-2.5 < x < 2.5';
HJIextraArgs.visualize.yTitle = '-2.5 < y < 2.5';
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
  HJIPDE_solve(data, tau, schemeData, 'set', HJIextraArgs);