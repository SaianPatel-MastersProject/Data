function [vError, refVel, rCurvCurrent] = calculateVelocityError(currentPosition, currentVel, AIW_Data, vMax, vMin)

    % Get x and y position of the vehicle from currentPosition
    xV = currentPosition(1);
    yV = currentPosition(2);

    % Compute the derivatives of x and y from AIW data using central diff
    dx = gradient(AIW_Data(:,1));
    dy = gradient(AIW_Data(:,2));
    ddx = gradient(dx);
    ddy = gradient(dy);

    % Compute curvature
    curvature = (dx .* ddy - dy .* ddx) ./ (dx.^2 + dy.^2).^(3/2);

    % Compute radius of curvature
    rCurvature = 1 ./ curvature;

    % Re-interpolate rCurvature
    % rCurvature = interp1((1:100)', rCurvature, (linspace(1,100, 10000))', 'spline');

    % Map straights to inf
    rCurvature(isinf(rCurvature)) = inf;
    rCurvature = movmean(rCurvature, 5);
    % rCurvature(rCurvature > 200) = 200;
    rMin = min(rCurvature);
    rMax = max(rCurvature);

    % Find nearest AIW waypoint using Euclidean distance
    d = sqrt((AIW_Data(:,1) - xV).^2 + (AIW_Data(:,2) -yV).^2);
    [minDist, closestWaypointIdx] = min(d);

    rCurvCurrent = rCurvature(closestWaypointIdx);

    refVel = vMin + (vMax - vMin) .* ((rCurvCurrent - rMin) ./ (rMax - rMin));
    refVel = max(vMin, min(vMax, refVel));

    vError = currentVel - refVel;

end