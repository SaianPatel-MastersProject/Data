%% Function to rotate track points to align with the start vector defined by (x0, y0) and (x1,y1)
function rotatedTrackPoints = fnRotateTrackPoints(trackPoints, x0, y0, x1, y1)

    % Set x and y (converted to row vectors)
    x = trackPoints(:,1)';
    y = trackPoints(:,2)';

    % Compute direction vectors
    v0 = [x(2) - x(1), y(2) - y(1)];
    vT = [x1 - x0, y1 - y0];

    % Compute rotation angle
    theta_original = atan2(v0(2), v0(1));
    theta_target = atan2(vT(2), vT(1));
    theta = theta_target - theta_original;

    % Apply rotation matrix
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    rotated_points = R * [x; y];

    % Extract rotated coordinates
    xR = rotated_points(1, :);
    yR = rotated_points(2, :);

    % Save to output
    rotatedTrackPoints = [xR', yR'];




end