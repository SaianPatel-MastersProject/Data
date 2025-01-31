%% Function to Create a Circle Track
function circTrainingLine = fnCreateCircle(matFilePath, lapNumber, r, direction, nPoints)

    % Load in the mat
    load(matFilePath);

    % Filter the data to the specified lap
    lapData = runStruct.data(runStruct.data.lapNumber == lapNumber, :);
    
    % Get x, y, z, throttle and brake
    x0 = lapData.posX(1);
    y0 = lapData.posY(1);
    x1 = lapData.posX(2);
    y1 = lapData.posY(2);
    z = lapData.posZ(1:nPoints); % This is OK for 2kF
    rThrottle = ones([nPoints,1]);
    rBrake = zeros([nPoints,1]);

    % Compute the direction vectors
    dx = x1 - x0;
    dy = y1 - y0;
    d = sqrt(dx^2+dy^2);

    % Normalise the direction vectors
    dx = dx / d;
    dy = dy / d;

    % Compute the perpendicular vectors
    px = -dy;
    py = dx;

    % Compute possible centers
    cx1 = x0 + r * px;
    cy1 = y0 + r * py;
    cx2 = x0 - r * px;
    cy2 = y0 - r * py;

    % Choose the center that results in a clockwise motion
    cross1 = dx * (cy1 - y0) - dy * (cx1 - x0);
    cross2 = dx * (cy2 - y0) - dy * (cx2 - x0);

    % Compute the centers based on direction
    switch direction
        case 'cw'

            if cross1 < 0

                cx = cx1;
                cy = cy1;

            else

                cx = cx2;
                cy = cy2;

            end

        case 'ccw'

            if cross1 > 0

                cx = cx1;
                cy = cy1;

            else

                cx = cx2;
                cy = cy2;

            end

    end

    % Generate circular trajectory
    theta = (linspace(0, 2*pi, nPoints))';
    x = cx + r * cos(theta);
    y = cy + r * sin(theta);
    
    % Format for the driving training line
    % [X, Y, Z] to [Y, Z, -X]
    circTrainingLine = [y, z, -x, rThrottle, rBrake];

end