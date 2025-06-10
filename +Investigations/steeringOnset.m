%% Driver Deadzone
obj = Plotting.multiPlotter();

% Add training run
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', true, [2:10]); % SP
% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R04.mat', true, [2:4]); % SM94

% Add reference lap
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', 10); % SP
% obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R04.mat', 4); % SM94

%% Detect Steering Onset
threshold = 1; %deg/s

dSteer1 = [0; diff(obj.runData(1).runData.steerAngle .* 225)] ./ 0.01;

% Identify where steering is active
steerActive = abs(dSteer1) > threshold;

% Find rising edges
onset = find([0; diff(steerActive)] == 1);

%%

onsetCTE = obj.runData(1).runData.CTE(onset);

%% Plot

figure;
grid on;
grid minor;
scatter(obj.runData(1).runData.CTE(onset), dSteer1(onset))