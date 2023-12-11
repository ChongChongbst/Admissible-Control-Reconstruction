function combined = combine(admiss1, g1, admiss2, g2, compMethod, u)
% Use the 2 admissible control sets to find the admissible set combination

%% Step 1: form a combined grid
grid_min = [g1.min(1); g2.min(1); g1.min(2)];
grid_max = [g1.max(1); g2.max(1); g2.max(2)]; 
pdDims = 3;               
N = [g1.N(1); g2.N(1); g2.N(2)];         % Number of grid point
g = createGrid(grid_min, grid_max, N, pdDims);

%% Step 2: Find the combined admissible sets
dim_x = size(admiss1.u_max, 1);
dim_y = size(admiss2.u_max, 1);

u1_max_expand = permute(repmat(admiss1.u_max,[1 1 1 dim_y]), [1 4 2 3]);
u2_max_expand = permute(repmat(admiss2.u_max,[1 1 1 dim_x]), [4 1 2 3]);

u1_min_expand = permute(repmat(admiss1.u_min,[1 1 1 dim_y]), [1 4 2 3]);
u2_min_expand = permute(repmat(admiss2.u_min,[1 1 1 dim_x]), [4 1 2 3]);

u_max_combine= min(u1_max_expand, u2_max_expand);
u_min_combine = max(u1_min_expand, u2_min_expand);


%% check deriv
% deriv1 = permute(reshape(cell2mat(admiss1.deriv), [81,81,81]), [3 1 2]);
% deriv2 = permute(reshape(cell2mat(admiss2.deriv), [81,81,81]), [3 1 2]);
% deriv1 = permute(repmat(deriv1, [1 1 1 dim_y]), [1 4 2 3]);
% deriv2 = permute(repmat(deriv2, [1 1 1 dim_x]), [4 1 2 3]);
% u_max_combine(deriv1==0) = u2_max_expand(deriv1==0);
% u_min_combine(deriv1==0) = u2_min_expand(deriv1==0);
% u_max_combine(deriv2==0) = u1_max_expand(deriv2==0);
% u_min_combine(deriv2==0) = u1_min_expand(deriv2==0);

% 
% deriv = deriv1+deriv2;
i_exclude = u_min_combine > u_max_combine;
% 
u_max_combine(i_exclude) = 0;
u_min_combine(i_exclude) = 0;

% u_max_combine(i_exclude & (deriv>=0)) = u(1);
% u_min_combine(i_exclude & (deriv>=0)) = u(1);
% u_max_combine(i_exclude & (deriv<0)) = u(2);
% u_min_combine(i_exclude & (deriv<0)) = u(2);

set_vis = ones([g.shape, size(admiss1.u_min,3)]);
set_vis(i_exclude) = 2;



%% Step 3: Arrange outputs
combined.g = g;
combined.u_min = u_min_combine;
combined.u_max = u_max_combine;
combined.set_vis = set_vis;
