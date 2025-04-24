%% Build sLap Wind Profile which affects yaw rate

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

%% Specify yaw rate gain change at given sLap [sLap, dYawRateGain]
windProfile = [
    0, 0.01; % SF
    700, 0.01;
    800, 0;
    900, 0;
    1000, 0;
    1600, 0;
    1800, 0;
    2000, 0;
    2200, 0;
    2400, 0;
    2600, 0;
    2800, 0;
    3000, 0;
    3400, 0;
    3600, 0;
    3700, 0;
    3900, 0;
    4000, 0;
    4200, 0;
    4400, 0.01;
    sLap(end), 0.01;
];

%% Interpolate
windProfileInterp = interp1(windProfile(:,1), windProfile(:,2), sLap, 'linear');

%% Plot the wind profile
figure;
grid on;
grid minor;
plot(sLap, windProfileInterp);