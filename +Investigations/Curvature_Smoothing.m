%% Curvature Investigation
% Read Data
AIW_Table = readtable('+PostProcessing\+CTE\Arrow_IP.csv');

%% Raw Calculation

AIW_Data = [AIW_Table.x, AIW_Table.y];
dBetweenPoints = (sqrt(diff(AIW_Data(:,1)).^2 + diff(AIW_Data(:,2)).^2));
rollingDistance = [0; cumsum(dBetweenPoints)];


% Get the curvature, kappa
[kappa, ~] = PostProcessing.PE.fnCalculateCurvature(AIW_Data);

figure("Name", 'nPoints = Number of Elements')
plot(rollingDistance, kappa)
xlabel('Lap Distance (m)')
ylabel('Curvature \kappa')


%% Sweep nPoints

nPoints  = flip([150, 750, 2000, 10000]);
interpMethod = 'spline';

AIW_Data = [AIW_Table.x, AIW_Table.y];
dBetweenPoints = (sqrt(diff(AIW_Data(:,1)).^2 + diff(AIW_Data(:,2)).^2));
rollingDistance = [0; cumsum(dBetweenPoints)];

figure("Name", 'nPoints Sweep');
hold on

for i = 1:numel(nPoints)

    dNew = (linspace(0, rollingDistance(end), nPoints(i)))';
    xInterp = interp1(rollingDistance, AIW_Data(:,1), dNew, interpMethod);
    yInterp = interp1(rollingDistance, AIW_Data(:,2), dNew, interpMethod);
    
    % Get the curvature, kappa
    [kappa, ~] = PostProcessing.PE.fnCalculateCurvature([xInterp, yInterp]);
    plot(dNew, kappa)


end
xlabel('Lap Distance (m)')
ylabel('Curvature \kappa')
legend(flip({'150', '750', '2000', '10000'}))

%% Interpolate every s (m)

s  = ([0.1, 1, 5, 10]);
interpMethod = 'spline';

AIW_Data = [AIW_Table.x, AIW_Table.y];
dBetweenPoints = (sqrt(diff(AIW_Data(:,1)).^2 + diff(AIW_Data(:,2)).^2));
rollingDistance = [0; cumsum(dBetweenPoints)];

figure("Name", 'Distance Sweep');
hold on

for i = 1:numel(nPoints)

    dNew = (0:s(i):rollingDistance(end))';
    xInterp = interp1(rollingDistance, AIW_Data(:,1), dNew, interpMethod);
    yInterp = interp1(rollingDistance, AIW_Data(:,2), dNew, interpMethod);
    
    % Get the curvature, kappa
    [kappa, ~] = PostProcessing.PE.fnCalculateCurvature([xInterp, yInterp]);
    plot(dNew, kappa)


end
xlabel('Lap Distance (m)')
ylabel('Curvature \kappa')
legend({'s=0.1', 's=1', 's=5', 's=10'})

%% Interpolate Raw Kappa

nPoints  = flip([150, 750, 2000, 10000]);
interpMethod = 'spline';

AIW_Data = [AIW_Table.x, AIW_Table.y];
dBetweenPoints = (sqrt(diff(AIW_Data(:,1)).^2 + diff(AIW_Data(:,2)).^2));
rollingDistance = [0; cumsum(dBetweenPoints)];

% Get the curvature, kappa
[kappa, ~] = PostProcessing.PE.fnCalculateCurvature(AIW_Data);

figure("Name", 'Interpolate Kappa');
hold on

for i = 1:numel(nPoints)

    dNew = (linspace(0, rollingDistance(end), nPoints(i)))';
    kappaInterp = interp1(rollingDistance, kappa, dNew, interpMethod);

    plot(dNew, kappaInterp)


end
xlabel('Lap Distance (m)')
ylabel('Curvature \kappa')
legend({'10000', '2000', '750', '150'})