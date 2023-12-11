function [u_ad_min, u_ad_max] = admis(obj, yLast, y, schemeData, t, deltaT)
%       [u_ad_min, u_ad_max] = admis(obj, y, schemeData, t, deltaT)
% Calculate the admissible control for BRS in particular one time step
%       * This process is for Dubins Car Full System *
%       Fullsystem: dot{x}_1 = v * cos(theta) + d1
%                   dot{x}_2 = v * sin(theta) + d2
%                   dottheta = w = u           u\in[umin, umax]
% Case 1:
%       minimal bound (umin_full): uOpt
%       maximal bound (umax_full): 0 = V(x,T) + [(Vx_1)*dot{x}_1 + (Vx_2)*dot{x}_2 + (Vtheta)*dottheta] * deltaT
%                               dottheta = [-V(x,T)/deltaT - (Vx_1)*dot{x}_1 - (Vx_2)*dot{x}_2]/(Vtheta)   
%   u_admis = [u_ad_min, u_ad_max] = [umin, umax] \intersect [umin_full, umax_full]
%
% Case 2:
%       maximal bound (umax_full): uOpt
%       minimal bound (umin_full): 0 = V(x,T) + [(Vx_1)*dot{x}_1 + (Vx_2)*dot{x}_2 + (Vtheta)*dottheta] * deltaT
%                               dottheta = [-V(x,T)/deltaT - (Vx_1)*dot{x}_1 - (Vx_2)*dot{x}_2]/(Vtheta) 
%   u_admis = [u_ad_min, u_ad_max] = [umin, umax] \intersect [umin_full, umax_full]
%       
% Use the information in [1.schemeData & 2.deriv] to decide which computation case to use
%       if Enforcable and deriv{2}>0: Case 1
%          Enforcable and deriv{2}<0: Case 2
%
%       if Inevitable and deriv{2}>0: Case 2
%          Inevitable and deriv{2}<0: Case 1
%
%% Extract the useful information
  dynSys = schemeData.dynSys;
  u = dynSys.wRange;
  grid = schemeData.grid;
  
  data = reshape(y,grid.shape);
  dataLast = reshape(yLast,grid.shape);

  if ~isfield(schemeData, 'dMode')
    schemeData.dMode = 'max';
  end
  fprintf('the deltaT is %f', deltaT)

%% Get upwinded and centered derivative approximations.
%   derivL = cell(grid.dim, 1);
%   derivR = cell(grid.dim, 1);
%   derivC = cell(grid.dim, 1);
%     
%  
%   for i = 1 : grid.dim
%     [ derivL{i}, derivR{i} ] = feval(schemeData.derivFunc, grid, dataLast, i);
%     derivC{i} = 0.5 * (derivL{i} + derivR{i});
%   end
% 
%   deriv = derivC;

  deriv = computeGradients(grid, dataLast);

  uOpt = dynSys.optCtrl(t, grid.xs, deriv, schemeData.uMode);
  dOpt = dynSys.optDstb(t, grid.xs, deriv, schemeData.dMode);
  dx = dynSys.dynamics(t, grid.xs, uOpt, dOpt);
%% Initialize the admissible control set for this subsystem
  u_ad_min = ones(size(data))*2;
  u_ad_max = ones(size(data))*-2;

%% Except the Case where deriv{3} == 0
  if schemeData.uMode == 'min'
      i_set = find(data<=0);
  else if schemeData.uMode == 'max'
      i_set = find(data>=0);
  end
  
  i_0 = find(deriv{3} == 0);
  ind_0 = intersect(i_0, i_set);
  u_ad_min(ind_0) = u(1);
  u_ad_max(ind_0) = u(2);

%% Decide the computation case
  policy = zeros(size(data));
  i_p = find(deriv{3}>0);
  i_n = find(deriv{3}<0);
  if schemeData.uMode == 'min'
    policy(i_p) = 1;
    policy(i_n) = 2;
  elseif schemeData.uMode == 'max'
    policy(i_p) = 2;
    policy(i_n) = 1;
  end

%% Apply computation based on the policy
  i_1 = find(policy == 1);
  i_2 = find(policy == 2);
  ind_1 = intersect(i_1, i_set);
  ind_2 = intersect(i_2, i_set);
  u_ad_min(ind_1) = uOpt(ind_1);
  u_ad_max(ind_2) = uOpt(ind_2);

%   u_ad_max(ind_1) = max(min((-data(ind_1)/deltaT - (deriv{1}(ind_1)).*dx{1}(ind_1))./(deriv{2}(ind_1)), u(2)), u(1));
%   u_ad_min(ind_2) = min(max((-data(ind_2)/deltaT - (deriv{1}(ind_2)).*dx{1}(ind_2))./(deriv{2}(ind_2)), u(1)), u(2));

  u_ad_max(ind_1) = min((-dataLast(ind_1)/deltaT - (deriv{1}(ind_1)).*dx{1}(ind_1) - (deriv{2}(ind_1)).*dx{2}(ind_1))./(deriv{3}(ind_1)), u(2));
  u_ad_min(ind_2) = max((-dataLast(ind_2)/deltaT - (deriv{1}(ind_2)).*dx{1}(ind_2) - (deriv{2}(ind_2)).*dx{2}(ind_2))./(deriv{3}(ind_2)), u(1));

  u_ad_min(u_ad_min==2) = NaN;
  u_ad_min(u_ad_max==-2) = NaN;
  u_ad_max(u_ad_min==2) = NaN;
  u_ad_max(u_ad_max==-2) = NaN;


% %% Visualization -- for the subsystem of Dubins Car
%   h1 = surf(grid.xs{1}, grid.xs{2}, u_ad_min);
%   h1.EdgeColor = 'none';
%   h1.FaceColor = 'b';
%   h1.FaceAlpha = .5;
%   h1.FaceLighting = 'phong';
%   view(45,45);

%   h2 = surf(grid.xs{1}, grid.xs{2}, u_ad_max);
%   h2.EdgeColor = 'none';
%   h2.FaceColor = 'b';
%   h2.FaceAlpha = .5;
%   h2.FaceLighting = 'phong';
  
  
end