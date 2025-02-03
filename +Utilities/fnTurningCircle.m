%% Function to get maximum curvature and minimum radius
function [kappaMax, rMin] = fnTurningCircle(v, k)

    % In the simple vehicle model, steering angle ([-1, 1]) dictates yaw
    % rate by dPsi = delta * k

    % Maximum curvature and therefore minimum radius is defined by v =
    % omega * r, where omega is dPsi
    dPsi = 1 * k;

    rMin = v / dPsi;

    kappaMax = 1 / rMin;


end