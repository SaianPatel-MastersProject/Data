%% Future State Prediction

%% Load a Run
obj = Plotting.multiPlotter();
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', 10); % Human

%% Set constants
previewTime = 0.2;
n = previewTime/0.01;
v = 40;
tDummy = (0.01:0.01:previewTime)';

%% Calculate yawAngles and yawRates at each time step
dX = [diff(obj.data(1).lapData.posX)];
dY = [diff(obj.data(1).lapData.posY)];
thetaV = atan2(dY, dX);
thetaV = [thetaV; thetaV(end)];

% Use Euler Forward Integration
yawAngle = zeros([numel(obj.data(1).lapData.tLap), 1]);
yawRate = obj.data(1).lapData.steerAngle .* -1.5;
for i = 2:numel(yawAngle)

    yawAngle(i,1) = thetaV(i-1) + yawRate(i-1) * 0.01;


end
yawAngle(1,1) = yawAngle(2,1);

%% Calculate steering velocities
dSteerAngle = [0; diff(obj.data(1).lapData.steerAngle)] ./ 0.01; % Dont convert to degrees

%% At each point, go back 200ms and project forward, assuming steering velocity is constant in the 200ms period
for i = 2:numel(yawRate)

    dSteer_i = dSteerAngle(i-1);

    yawAngle_i = yawAngle(i-1);

    steerAngle_i = obj.data(1).lapData.steerAngle(i-1);

    % Integrate dSteer to get a steering angle profile over the 200ms
    % period
    dSteerWindow = zeros([n, 1]);
    dSteerWindow(:,1) = dSteer_i;
    steerWindow = steerAngle_i + cumsum(dSteerWindow) .* 0.01;

    % Produce the future window of yaw angles
    yawAngleWindow = zeros([n, 1]);
    yawAngleWindow(1,1) = yawAngle_i;
    for j = 2:n

        yawAngleWindow(j,1) = yawAngleWindow(j-1) + steerWindow(j-1)* -1.5 * 0.01;

    end

    % Use the final one to predict position
    yawAngleF = yawAngleWindow(end);
    
    % Predict change in position
    dXF = v * cos(yawAngleF) * previewTime;
    dYF = v * sin(yawAngleF) * previewTime;
    
    % Predict future position
    xF(i,1) = obj.data(1).lapData.posX(i) + dXF;
    yF(i,1) = obj.data(1).lapData.posY(i) + dYF;
end

%% Use the function
for i = 2:numel(yawRate)

    dSteer_i = dSteerAngle(i-1);

    yawAngle_i = yawAngle(i-1);

    steerAngle_i = obj.data(1).lapData.steerAngle(i-1);

    xV = obj.data(1).lapData.posX(i);

    yV = obj.data(1).lapData.posY(i);

    [xF_i, yF_i, ~] = Utilities.fnPredictFuturePosition(xV, yV, steerAngle_i, dSteer_i, yawAngle_i, 0.2, 40);
    
    % Predict future position
    xF2(i,1) = xF_i;
    yF2(i,1) = yF_i;
end
%% Calculate Errors based on future predictions
track = 'BAR';
AIW_Table = Utilities.fnLoadAIW(track);
xRefOriginal = [AIW_Table.x];
yRefOriginal = [AIW_Table.y];
xRef = Utilities.fnInterpolateByDist([xRefOriginal, yRefOriginal], xRefOriginal, 0.1, 'spline');
yRef = Utilities.fnInterpolateByDist([xRefOriginal, yRefOriginal], yRefOriginal, 0.1, 'spline');

dXF = diff(xF);
dYF = diff(yF);
psi = atan2(dYF, dXF);
psi = [psi; psi(end)];

futureCTE = zeros([numel(yawRate), 1]);
futureHE = futureCTE;
for i = 1:numel(yawRate)

    [CTE_i, ~, HE_i] = PostProcessing.PE.fnCalculatePathError([xF(i), yF(i), psi(i)], [xRef, yRef]);
    futureCTE(i) = CTE_i;
    futureHE(i) = HE_i;


end

%%
figure;
plot(obj.data(1).lapData.CTE(n:end))
hold on
plot(futureCTE)

%%
figure;
tQ = (1:100:numel(xF))';
plot(xRef, yRef, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 2)
hold on
plot(obj.data(1).lapData.posX, obj.data(1).lapData.posY, 'Color', 'red', 'LineWidth', 2)
scatter(obj.data(1).lapData.posX(tQ), obj.data(1).lapData.posY(tQ), 'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'red')
axis equal
grid on
grid minor
scatter(xF(tQ), yF(tQ),'filled', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'blue')

legend({'Target Racing Line', 'Driven Line', 'Car Points', 'Predicted Future State'})
