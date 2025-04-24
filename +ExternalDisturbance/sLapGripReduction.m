%% Build sLap Grip Reduction Profile which affects yaw rate

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

%% Specify linear grip reduction rate
yawRateGainLoss = 0.015; % 1% of 1.5
unitLossDistance = 500;
lossRate = yawRateGainLoss / unitLossDistance; % Loses x yaw rate potential every y (m) throughout the lap
lossRate = lossRate * 0.1;

%% Produce the grip reduction profile
% gripReductionProfile = (0:lossRate:(lossRate * (numel(sLap)-1)))';
gripReductionProfile = zeros([numel(sLap), 1]);
gripReductionProfile(:,1) = lossRate;

%% Simulate yaw rate gain change throughout the lap
lapYawRateGainInitial = -1.5;
lapYawRateGain = zeros([numel(sLap), 1]);
lapYawRateGain(1,1) = lapYawRateGainInitial;
for i = 2:numel(sLap)

    lapYawRateGain(i,1) = lapYawRateGain(i-1,1) + gripReductionProfile(i,1);


end
%% Plot the wind profile
figure;
grid on;
grid minor;
plot(sLap, lapYawRateGain);