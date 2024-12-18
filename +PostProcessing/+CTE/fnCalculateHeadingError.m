function headingError = fnCalculateHeadingError(AIW_data, x, y)
    
    xRef = AIW_data(:,1);
    yRef = AIW_data(:,2);

    % Compute gradient of reference trajectory
    dxRef = gradient(xRef);
    dyRef = gradient(yRef);

    % Get the heading for each reference point
    thetaRef = atan2(dyRef, dxRef);

    % Compute gradient of the car's trajectory
    dx = gradient(x);
    dy = gradient(y);

    % Get the heading of the car
    theta = atan2(dy, dx);

    % Initialise a dist2AIW array
    dist2AIW = [];

    % Initialise a heading error array
    headingError = [];

    % Loop through each point, find the closest AIW point
    for i = 1:size(x, 1)

        % Get the current point
        x_i = x(i);
        y_i = y(i);
        theta_i = theta(i);

        % Compute the distance to the AIW points from the current point
        dist2AIW = sqrt((xRef - x_i).^2 + (yRef - y_i).^2);

        % Find the index of the clsoest point
        [~, closestWaypointIdx] = min(dist2AIW);

        % Get the heading of the nearest point
        thetaRef_i = thetaRef(closestWaypointIdx);

        % Calculate the heading error
        headingError_i = thetaRef_i - theta_i;

        % Wrap it
        headingError(i, 1) = atan2(sin(headingError_i), cos(headingError_i));


    end












end