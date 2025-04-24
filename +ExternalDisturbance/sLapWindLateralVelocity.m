%% Build sLap Wind Profile which applies a lateral velocity 

%% Set Track Reference
track = 'BAR';
AIW_Table = Utilities.fnLoadAIW(track);
xRefOriginal = [AIW_Table.x];
yRefOriginal = [AIW_Table.y];
xRef = Utilities.fnInterpolateByDist([xRefOriginal, yRefOriginal], xRefOriginal, 0.1, 'spline');
yRef = Utilities.fnInterpolateByDist([xRefOriginal, yRefOriginal], yRefOriginal, 0.1, 'spline');

%% Produce an sLap Vector
dX = [0; diff(xRef)];
dY = [0; diff(yRef)];
d = sqrt( dX.^2 + dY.^2);
sLap = cumsum(d);

%% Specify lateral velocity change at given sLap [sLap, lateralVelocity, addedYaw] (right is -ve, left is +ve)
windProfile = [
    0, 1, 0.015; % SF
    700, 1, 0.015;
    800, 0, 0;
    900, 0, 0;
    1000, 0, 0;
    1600, 0, 0;
    1800, 0, 0;
    2000, 0, 0;
    2200, 0, 0;
    2400, 0, 0;
    2600, 0, 0;
    2800, 0, 0;
    3000, 0, 0;
    3400, 0, 0;
    3600, 0, 0;
    3700, 0, 0;
    3900, 0, 0;
    4000, 0, 0;
    4200, 0, 0;
    4400, 1, 0.015;
    sLap(end), 1, 0.015;
];

%% Interpolate
windProfileInterp = interp1(windProfile(:,1), windProfile(:,2), sLap, 'linear');
yawProfileInterp = interp1(windProfile(:,1), windProfile(:,3), sLap, 'linear');

%% Tie the crosswind to the AIW_Data
dXNorm = dX ./ d;
dXNorm(1,1) = 0;
dYNorm = dY ./ d;
dYNorm(1,1) = 0;

% Compute perp vectors
nX = -dYNorm;
nY = dXNorm;

% Scale by lateral velocity
nX_V = nX .* windProfileInterp;
nY_V = nY .* windProfileInterp;

%% Format the lateralVelocity Profile
lateralVelocityProfile = [nX_V, nY_V, zeros([numel(nX_V), 1]), yawProfileInterp];
%% Plot the wind profile
figure;
grid on;
grid minor;
plot(sLap, windProfileInterp);

%%
figure;
quiver(xRef, yRef, nX_V, nY_V); % 0 disables auto scaling
axis equal;
title("Perpendicular Vectors Scaled by Velocity");
xlabel('X'); ylabel('Y');