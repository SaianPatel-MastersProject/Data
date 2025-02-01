function transformed_points = extract_and_transform_trajectory(image_path, x0, y0, x1, y1)
    % Function to extract trajectory from an image, smooth it, translate, and rotate
    
    % Load and display image
    img = imread(image_path);
    figure;
    imshow(img);
    hold on;
    title('Click to define trajectory points. Press Enter when done.');

    % Get user-selected points
    [x, y] = ginput;

    y = -y;
    
    % Close figure after selection
    close;
    
    % Ensure sufficient points
    if length(x) < 2
        error('At least two points are required.');
    end
    
    % Get the distance between the points
    dx = [0; diff(x)];
    dy = [0; diff(y)];
    dRolling = sqrt(dx.^2+dy.^2);
    d = cumsum(dRolling);

    % Interpolate by sampling every 1 unit length
    dNew = (0:1:d(end));
    % x_smooth = interp1(d, x, dNew, 'spline');
    % y_smooth = interp1(d, y, dNew, 'spline');
    x_smooth = spline(d, x, dNew);
    y_smooth = spline(d, y, dNew);

    % Interpolate using a spline for smoothing
    % t = 1:length(x); % Parameter for interpolation
    % tt = linspace(1, length(x), 100); % More resolution
    % x_smooth = spline(t, x, tt);
    % y_smooth = spline(t, y, tt);

    % Translate to start at (x0, y0)
    dx = x_smooth(1) - x0;
    dy = y_smooth(1) - y0;
    x_translated = x_smooth - dx;
    y_translated = y_smooth - dy;

    % Compute rotation angle to align first two points with (x0,y0) → (x1,y1)
    vec_original = [x_translated(2) - x_translated(1), y_translated(2) - y_translated(1)];
    vec_target = [x1 - x0, y1 - y0];
    
    % Compute rotation angle
    theta = atan2(vec_target(2), vec_target(1)) - atan2(vec_original(2), vec_original(1));

    % Apply rotation
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    rotated_points = R * [x_translated; y_translated];

    % Extract final transformed coordinates
    x_final = rotated_points(1, :);
    y_final = rotated_points(2, :);
    
    % Store output points
    transformed_points = [x_final', y_final'];
    
    % Plot the transformed trajectory
    figure;
    plot(x_final, y_final, 'r-', 'LineWidth', 2);
    hold on;
    plot(x0, y0, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8); % Start point
    plot(x1, y1, 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8); % Direction point
    axis equal; grid on;
    xlabel('X'); ylabel('Y');
    title('Transformed Trajectory');
    legend('Smoothed Trajectory', 'Start Point', 'Direction Point');
end
