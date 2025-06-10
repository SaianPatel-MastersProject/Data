%% PID vs Human - BAR
obj = Plotting.multiPlotter();

%% Runs
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', true, [2:10]); % SP
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03_AvgLap.mat', true, []); % SP
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_21\2025_FYP04_21_D2_R01.mat', true, [1]); % PID



%% Add Laps
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', 10); % SP
obj = obj.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03_AvgLap.mat'); % SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_21\2025_FYP04_21_D2_R01.mat', 1); % PID