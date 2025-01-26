%% Function to calculate curvature (kappa)
function [kappa, rCurvature] = fnCalculateCurvature(AIW_Data)

    % Compute the derivatives of x and y from AIW data using central diff
    dx = gradient(AIW_Data(:,1));
    dy = gradient(AIW_Data(:,2));
    ddx = gradient(dx);
    ddy = gradient(dy);


    % Compute curvature
    curvature_signed = (dx .* ddy - dy .* ddx) ./ (dx.^2 + dy.^2).^(3/2);

    % Set kappa
    kappa = movmean(curvature_signed, 25);

    % Set rCurvature
    rCurvature = 1./ kappa;


end