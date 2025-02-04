%% Check maximum turning radius

% Define parameters
V = 40; % m/s (constant speed)
deltaMax = 225; % degrees (maximum steering angle)
k = 1.5; % steering gain
dt = 0.01; % Time step (s)
nPoints = 100; % Number of time steps

% Initialize arrays for position and heading
pos = zeros(nPoints, 2);
theta = zeros(nPoints, 1); % Heading angle

% Compute the effective steering angle
delta_eff = k * deg2rad(deltaMax);

% Compute angular velocity
omega = V * tan(delta_eff) / V; % Simplified assumption

% Initialize curvature array
curvature = zeros(nPoints, 1);

% Simulate the trajectory
for i = 2:nPoints
    theta(i) = theta(i-1) + omega * dt; % Update heading
    pos(i, 1) = pos(i-1, 1) + V * cos(theta(i)); % Update x position
    pos(i, 2) = pos(i-1, 2) + V * sin(theta(i)); % Update y position
    curvature(i) = omega / V; % Compute curvature
end

% Plot the trajectory
figure;
plot(pos(:, 1), pos(:, 2), 'b', 'LineWidth', 2);
xlabel('X Position (m)');
ylabel('Y Position (m)');
title('Vehicle Trajectory');
grid on;
axis equal;
legend('Trajectory');

% Plot the curvature over time
figure;
plot((0:nPoints-1) * dt, curvature, 'r', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Curvature (1/m)');
title('Curvature Over Time');
grid on;
legend('Curvature');
