function V = StateWAdms(grid, initial_data, tau, u_adms, dynSys)

tStart = cputime;
x = grid.xs;
dt = tau(2) - tau(1);

xs = zeros(prod(grid.N, 'all'),3);
xs(:,1) = reshape(x{1}, 1, []);
xs(:,2) = reshape(x{2}, 1, []);
xs(:,3) = reshape(x{3}, 1, []);

for t = length(tau):-1:2
    u_admsi = u_adms(:,:,:,t);

    u = eval_u(grid, u_admsi, xs, 'cubic');
    dx = dynSys.dynamics(tau, xs, u);  
    xs = xs + dx * dt;

end

V = reshape(eval_u(grid, initial_data, xs, 'cubic'), grid.N');
tEnd = cputime - tStart



end
