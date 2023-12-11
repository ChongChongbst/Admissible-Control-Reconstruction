function dx = dynamics(obj, ~, x, u, d)
% Dynamics of the Dubins Car
%    \dot{x}_1 = v * cos(x_3) + d1
%    \dot{x}_2 = v * sin(x_3) + d2
%    \dot{x}_3 = w
%   Control: u = w;
%
% Mo Chen, 2016-06-08

if nargin < 5
  d = {0; 0; 0};
end

if iscell(x)
  dx = cell(length(obj.dims), 1);
  
  for i = 1:length(obj.dims)
    dx{i} = dynamics_cell_helper(obj, x, u, d, obj.dims, obj.dims(i));
  end
else
  if size(x) == 3
      dx = zeros(obj.nx, 1);
      
      dx(1) = obj.speed * cos(x(3));
      dx(2) = obj.speed * sin(x(3));
      dx(3) = u;
  end
%   x = reshape(x, [61*61*40, 3]);
  dx = zeros(size(x));
  
  dx(:,1) = obj.speed .* cos(x(:,3));
  dx(:,2) = obj.speed .* sin(x(:,3));
  dx(:,3) = u;
end
end

function dx = dynamics_cell_helper(obj, x, u, d, dims, dim)

switch dim
  case 1
    dx = obj.speed * cos(x{dims==3}) + d{1};
  case 2
    dx = obj.speed * sin(x{dims==3}) + d{2};
  case 3
    dx = u + d{3};
  otherwise
    error('Only dimension 1-3 are defined for dynamics of DubinsCar!')
end
end