function new_compare()
%% find Admissible Control set with Decomposition method
decomposed = decomposition('set', 'min');
data1 = decomposed.part1.data;
data2 = decomposed.part2.data;
admiss1 = decomposed.part1.admiss;
admiss2 = decomposed.part2.admiss;

tau = decomposed.tau;

%% The BRS Intersection of the two subsystem
dim_x = size(data1, 1);
dim_y = size(data2, 1);

data1_expand = permute(repmat(data1,[1 1 1 dim_y]), [1 4 2 3]);
data2_expand = permute(repmat(data2,[1 1 1 dim_x]), [4 1 2 3]);
data_intersection = max(data1_expand, data2_expand);

%% See if u_adms,1 could reconstruct BRS of subsystem 1
digits(4);

u_adms = 0.5*(admiss1.u_min+admiss1.u_max);
dsys1 = sys1([0, 0], 1, 1);

grid_min = [-2; -pi]; % Lower corner of computation domain
grid_max = [2; pi];    % Upper corner of computation domain
N = [160; 80];         % Number of grid points per dimension
pdDims = 2;               % 2nd dimension is periodic
g_1 = createGrid(grid_min, grid_max, N, pdDims);

R = 1;
% data = shapeRectangleByCorners(grid, lower, upper)
initial_data = shapeRectangleByCorners(g_1, [-R; -pi], [R; pi]);

% Convert Subscripts to linear indices
ind = sub2ind(g_1.shape,[38],[21]);

tStart = cputime;
x = g_1.xs;
dt = tau(2)-tau(1);

dt = dt;

% deltaT = dt/10;

% integratorOptions = odeCFLset('factorCFL', 0.8, 'singleStep', 'on');

xs = zeros(prod(g_1.N, 'all'),2);
xs(:,1) = reshape(x{1}, 1, []);
xs(:,2) = reshape(x{2}, 1, []);

X = xs(ind,1)
Theta = xs(ind,2)



for t = length(tau):-1:2
    u_admsi = u_adms(:,:,t);

    u = eval_u(g_1, u_admsi, xs, 'cubic');
    dx = dsys1.dynamics(t, xs, u);  
    xs = xs + dx * dt;
%     [ t, xs, schemeData ] = odeCFL3(schemeFunc, [tNow tau(t-1)], xs, integratorOptions, schemeData);
    U = u(ind)
    X = xs(ind,1)
    Theta = xs(ind,2)
end

V = reshape(eval_u(g_1, initial_data, xs, 'cubic'), g_1.N');
tEnd = cputime - tStart

figure('Position', [1, 1, 400, 400])
extraVis1.alpha = 0.3;
extraVis1.level = [0,0];                                      
extraVis2.alpha = 0.5;
extraVis1.contour_color = 'r';
visfuncIm_chong(g_1, V,'r', extraVis1);
hold on;
visfuncIm_chong(g_1,data1(:,:,size(data1,3)),'#0B0',extraVis2);
grid on
% lgd1 = legend('Sure BRS','True BRS');
% lgd1.FontSize = 25;

%% See if u_adms,2 could reconstruct BRS of subsystem 2
u_adms = 0.5*(admiss2.u_min+admiss2.u_max);
dsys2 = sys2([0, 0], 1, 1);

grid_min = [-2; -pi]; % Lower corner of computation domain
grid_max = [2; pi];    % Upper corner of computation domain
N = [160; 80];         % Number of grid points per dimension
pdDims = 2;               % 2nd dimension is periodic
g_2 = createGrid(grid_min, grid_max, N, pdDims);

R = 1;
% data = shapeRectangleByCorners(grid, lower, upper)
initial_data = shapeRectangleByCorners(g_2, [-R; -pi], [R; pi]);

% Convert Subscripts to linear indices
ind = sub2ind(g_2.shape,[38],[21]);

tStart = cputime;
x = g_1.xs;
dt = tau(2)-tau(1);


% deltaT = dt/10;

% integratorOptions = odeCFLset('factorCFL', 0.8, 'singleStep', 'on');

xs = zeros(prod(g_2.N, 'all'),2);
xs(:,1) = reshape(x{1}, 1, []);
xs(:,2) = reshape(x{2}, 1, []);

X = xs(ind,1)
Theta = xs(ind,2)



for t = length(tau):-1:2
    u_admsi = u_adms(:,:,t);
    u = eval_u(g_2, u_admsi, xs, 'cubic');
    dx = dsys2.dynamics(t, xs, u);  
    xs = xs + dx * dt;
%     [ t, xs, schemeData ] = odeCFL3(schemeFunc, [tNow tau(t-1)], xs, integratorOptions, schemeData);
    U = u(ind)
    X = xs(ind,1)
    Theta = xs(ind,2)
end

V = reshape(eval_u(g_2, initial_data, xs, 'cubic'), g_2.N');
tEnd = cputime - tStart

figure('Position', [1, 1, 400, 400])
extraVis1.alpha = 0.3;
extraVis1.level = [0,0];                                      
extraVis2.alpha = 0.5;
extraVis1.contour_color = 'r';
visfuncIm_chong(g_2, V,'r', extraVis1);
hold on;
visfuncIm_chong(g_2,data2(:,:,size(data2,3)),'#0B0',extraVis2);
grid on
% lgd1 = legend('Sure BRS','True BRS');
% lgd1.FontSize = 25;
%% The Admissible intersection of the two subsystems: u_adms in full dimensional system
combined = combine(admiss1, decomposed.g, admiss2, decomposed.g, 'min', [-1, 1]);
% combined = combine_time(admiss1, decomposed.g, admiss2, decomposed.g);

u_min_combine = combined.u_min;
u_max_combine = combined.u_max;

u_adms = 0.5*(u_max_combine+u_min_combine);

%% Find the grid and true data of the full system
grid_min = [-2; -2; -pi]; % Lower corner of computation domain
grid_max = [2; 2; pi];    % Upper corner ofs per dimension
pdDims = 3;               % 3rd dimension is periodic computation domain
N = [160; 160; 80];         % Number of grid point
g = createGrid(grid_min, grid_max, N, pdDims);

R = 1;
% data = shapeRectangleByCorners(g, [-R; -R; -pi], [R; R; pi]);
data = shapeCylinder(g, 3, [0,0], R);

% Time vector
t0 = 0;
tMax = 0.5;
dt = 0.01;
tau = t0:dt:tMax;

% Full-dimensional system
speed = 1;
wMax = 1;
dCar = DubinsFullCar([-2.5,1.5,0], wMax, speed);

% Find the true result (Inexact Decomposition Case)
full = fullsysDubins('set', 'min');
data_full = full.part;


%% Updating initial data with admissible control set, Find admissible BRS: 

data_new_mid = StateWAdms(g, data, tau, u_adms, dCar);


%% Quantitative Measurement
[JI, FI, FE] = jaccard(g,data_intersection(:,:,:,size(data_intersection,4)),data_full(:,:,:,size(data_full,4)))

[JI, FI, FE] = jaccard(g,data_new_mid,data_full(:,:,:,size(data_full,4)))



%% Computare the sureBRS, tureBRS and admsBRS
% data_new = round(data_new, 2);
figure('Position', [1, 1, 800, 400])%

% subplot(2,2,2) 
extraVis1.FaceAlpha = 0.6;
extraVis2.FaceAlpha = 0.5;
% visSetIm_trans(g,data_new_mid,'r',0, extraVis2);
% visSetIm_trans(g,data_full(:,:,:,size(data_full,4)),'#0B0',0,extraVis1);
% grid on
% set(gca,'xticklabels',[])
% set(gca,'yticklabels',[])
% set(gca,'zticklabels',[])
% % lgd1 = legend('Sure BRS','True BRS');
% % lgd1.FontSize = 20;
% 
% subplot(2,2,1) 
% extraVis1.FaceAlpha = 0.3;
% extraVis2.FaceAlpha = 0.6;
% visSetIm_trans(g,data_intersection(:,:,:,size(data_intersection,4)),'b',0, extraVis1);
% visSetIm_trans(g,data_full(:,:,:,size(data_full,4)),'#0B0',0,extraVis2);
% grid on
% set(gca,'xticklabels',[])
% set(gca,'yticklabels',[])
% set(gca,'zticklabels',[])


subplot(1,2,1)
h2 = visSetIm_trans(g,data_intersection(:,:,:,size(data_intersection,4)),'#1E88E5',0,extraVis1);
visSetIm_trans(g,data_full(:,:,:,size(data_full,4)),'#4A0A21',0,extraVis1);
grid off
set(gca,'xticklabels',[])
set(gca,'yticklabels',[])
set(gca,'zticklabels',[])
% lgd2 = legend('Unsure BRS','True BRS');
% lgd2.FontSize = 25;
% lgd1 = legend(h,'UnsureBRS');
% lgd1.FontSize = 20;

subplot(1,2,2)
h1 = visSetIm_trans(g,data_new_mid,'#FFC107',0,extraVis2);
h3 = visSetIm_trans(g,data_full(:,:,:,size(data_full,4)),'#4A0A21',0,extraVis1);
grid off
set(gca,'xticklabels',[])
set(gca,'yticklabels',[])
set(gca,'zticklabels',[])

lgd2 = legend([h1,h2,h3],'Admissible BRS','BRS from SCSD','True BRS');
lgd2.FontSize = 20;

% grid_min = [-2; -2]; % Lower corner of computation domain
% grid_max = [2; 2];    % Upper corner ofs per dimension
% N = [160; 160];         % Number of grid point
% g_d = createGrid(grid_min, grid_max, N, pdDims);
% subplot(1,3,3)
% visSetIm_trans(g_d,data_new_mid(:,:,50),'#FFC107',0,extraVis2);
% hold on
% visSetIm_trans(g_d,data_full(:,:,50,size(data_full,4)),'#4A0A21',0,extraVis1);
% hold on
% visSetIm_trans(g_d,data_intersection(:,:,50,size(data_intersection,4)),'#1E88E5',0,extraVis1);
% grid off
% xlabel('p_x','Fontsize',30);
% ylabel('p_y','FontSize',30);
% title('slice profile at θ = 45^{\circ}','Interpreter','tex','Fontsize',20)
% set(gca,'xticklabels',[])
% set(gca,'yticklabels',[])
% %% Compare SureBRS (Intersection) and trueBRS
% figure('Position', [1, 1, 400, 400])%
% % subplot(1,2,1) 
% extraVis1.FaceAlpha = 0.3;
% extraVis2.FaceAlpha = 0.5;
% visSetIm_trans(g,data_intersection(:,:,:,size(data_intersection,4)),'b',0, extraVis1);
% visSetIm_trans(g,data_full(:,:,:,size(data_full,4)),'#0B0',0,extraVis2);
% grid on
% set(gca,'xticklabels',[])
% set(gca,'yticklabels',[])
% set(gca,'zticklabels',[])
% lgd1 = legend('Unsure BRS','True BRS');
% lgd1.FontSize = 20;


end




