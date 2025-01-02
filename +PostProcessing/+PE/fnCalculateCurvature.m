%% Function to calculate curvature (kappa)
function [kappa, rCurvature] = fnCalculateCurvature(AIW_Data)

    % Compute the derivatives of x and y from AIW data using central diff
    dx = gradient(AIW_Data(:,1));
    dy = gradient(AIW_Data(:,2));
    ddx = gradient(dx);
    ddy = gradient(dy);

    % Compute curvature
    curvature = abs(dx .* ddy - dy .* ddx) ./ (dx.^2 + dy.^2).^(3/2);

    % Compute radius of curvature
    rCurvature = 1 ./ curvature;

    % Re-interpolate rCurvature
    % rCurvature = interp1((1:100)', rCurvature, (linspace(1,100, 10000))', 'spline');

    % Map straights to inf
    rCurvature(isinf(rCurvature)) = inf;
    rCurvature = movmean(rCurvature, 5);
    % rCurvature(rCurvature > 200) = 200;

    % Set kappa
    kappa = 1 ./ rCurvature;


end