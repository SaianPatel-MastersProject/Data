%% Read in data
AIW_Table = readtable('+PostProcessing\+CTE\Arrow.csv');
x = AIW_Table.x;
y = AIW_Table.y;

%% Fit spline to AIW
dx = diff(x);
dy = diff(y);
segment_lengths = sqrt(dx.^2 + dy.^2);
arc_lengths = [0; cumsum(segment_lengths)]; % Cumulative arc length

pp_x = spline(arc_lengths, x); % Parametric spline for x
pp_y = spline(arc_lengths, y); % Parametric spline for y

% Step 3: Generate points every 5 meters along the trajectory
step = 5; % Spacing in meters
new_arc_lengths = 0:step:arc_lengths(end); % New arc length positions

% Evaluate splines at the new arc lengths
new_x = ppval(pp_x, new_arc_lengths);
new_y = ppval(pp_y, new_arc_lengths);

% Display the results
fprintf('Generated %d points along the trajectory.\n', numel(new_x));

% Plot the original and resampled trajectory
figure;
plot(x, y, 'b-o', 'DisplayName', 'Original Points'); hold on;
plot(new_x, new_y, 'r-*', 'DisplayName', 'Resampled Points');
xlabel('X');
ylabel('Y');
legend;
title('Trajectory with Resampled Points');
grid on;
axis equal;

%%

% Assuming new_arc_lengths, pp_x, and pp_y are already defined from the previous step

% Step 1: Compute first and second derivatives of the splines
pp_dx = fnder(pp_x, 1); % First derivative of x
pp_dy = fnder(pp_y, 1); % First derivative of y
pp_ddx = fnder(pp_x, 2); % Second derivative of x
pp_ddy = fnder(pp_y, 2); % Second derivative of y

% Step 2: Evaluate the derivatives at the resampled arc lengths
dx = ppval(pp_dx, new_arc_lengths); % x'(s)
dy = ppval(pp_dy, new_arc_lengths); % y'(s)
ddx = ppval(pp_ddx, new_arc_lengths); % x''(s)
ddy = ppval(pp_ddy, new_arc_lengths); % y''(s)

% Step 3: Compute the curvature at each resampled point
curvature = abs(dx .* ddy - dy .* ddx) ./ (dx.^2 + dy.^2).^(3/2);

% Display results
fprintf('Calculated curvature for %d points.\n', numel(curvature));

% Optional: Plot curvature along the trajectory
figure;
plot(new_arc_lengths, curvature, 'r-', 'LineWidth', 1.5);
xlabel('Arc Length (s)');
ylabel('Curvature (\kappa)');
title('Curvature Along the Trajectory');
grid on;

%% Create some new data to use for waypoints
waypoints = [new_x', new_y', curvature'];