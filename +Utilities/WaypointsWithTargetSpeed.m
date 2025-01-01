function WaypointsWithTargetSpeed(aiwFilePath, maxSpeed, curvatureSensitivity)

    % Load the path data from a CSV file
    path_data = readtable(aiwFilePath); % Assumes columns 'x' and 'y' for coordinates
    
    % Initialize parameters
    v_max = maxSpeed;    % Maximum speed in units (e.g., m/s)
    k = curvatureSensitivity;         % Curvature sensitivity constant
    
    % Prepare an array to store target speeds
    target_speeds = zeros(height(path_data), 1);
    
    % Loop through each point to calculate curvature and target speed
    for i = 2:height(path_data)-1
        % Extract coordinates of the current, previous, and next points
        x_prev = path_data.x(i-1);
        y_prev = path_data.y(i-1);
        x_curr = path_data.x(i);
        y_curr = path_data.y(i);
        x_next = path_data.x(i+1);
        y_next = path_data.y(i+1);
        
        % Calculate curvature using the finite difference method
        numerator = abs((x_next - x_curr) * (y_curr - y_prev) - (x_curr - x_prev) * (y_next - y_curr));
        denominator = ((x_next - x_curr)^2 + (y_next - y_curr)^2)^(3/2);
        curvature = numerator / (denominator + eps); % Avoid division by zero with eps
        
        % Calculate target speed based on curvature
        target_speed = v_max / (1 + k * curvature);
        target_speeds(i) = target_speed;
    end
    
    % Set the first and last points to the maximum speed, as curvature can't be calculated
    target_speeds(1) = v_max;
    target_speeds(end) = v_max;
    
    % Add the target speed data to the table
    path_data.target_speed = target_speeds;
    
    % Save the updated table back to a new CSV file
    writetable(path_data, 'path_with_target_speeds.csv');
    
    disp('Target speeds calculated and saved to path_with_target_speeds.csv');

end
