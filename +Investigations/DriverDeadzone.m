%% Driver Deadzone
obj = Plotting.multiPlotter();

% Add training run
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', true, [2:10]); % SP
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_21\2025_FYP04_21_D1_R07.mat', true, [2:4]); % SM94
% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', true, [2:31]); % SP SUZ

% Add reference lap
% obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', 10); % SP
% obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R04.mat', 4); % SM94

%% Find where the steering is held 

dSteer1 = [0; diff(obj.runData(1).runData.steerAngle .* 225)] ./ 0.01;
dSteer2 = [0; diff(obj.runData(2).runData.steerAngle .* 225)] ./ 0.01;

% Find idx where dSteer is basically 0
xIdx1 = and(dSteer1 > -1, dSteer1 < 1);
xIdx2 = and(dSteer2 > -1, dSteer2 < 1);


%%
CTE_deadzone_1 = obj.runData(1).runData.HeadingError(xIdx1);
CTE_deadzone_2 = obj.runData(2).runData.HeadingError(xIdx2);

CTE_threshold_1 = [prctile(CTE_deadzone_1, 5), prctile(CTE_deadzone_1, 95)];
CTE_threshold_2 = [prctile(CTE_deadzone_2, 5), prctile(CTE_deadzone_2, 95)];

%% Plot
figure;
hold on
grid on
grid minor
scatter(CTE_deadzone_1, dSteer1(xIdx1), 5);
scatter(CTE_deadzone_2, dSteer2(xIdx2), 5);
xlabel('CTE')
ylabel('Steering Velocity')