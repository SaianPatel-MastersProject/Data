%%

obj = Plotting.multiPlotter();

% Add training run
% obj = obj.addRun('+ProcessedData/2024/FYP12_09/2024_FYP12_09_D4_R17.mat', true, []);
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D6_R04.mat', true, [2:32]);
% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP01_13\2025_FYP01_13_D7_R01.mat', true);

% Add reference lap
% obj = obj.addLap('+ProcessedData/2024/FYP12_09/2024_FYP12_09_D4_R17.mat', 12); % Human
% obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP01_20\2025_FYP01_20_D2_R01.mat', 3); % FFNN 21
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D6_R02.mat', 31); % FFNN 27
% obj = obj.addLap('+ProcessedData/2024/FYP12_30/2025_FYP12_30_D5_R43.mat', 1); % PID (Optimised)

%%
% Combine CTE and HE metrics tables
overallCTE = obj.data(1).metricsCTE;
overallHE = obj.data(1).metricsHE;
for i = 2:size(obj.data, 2)

    overallCTE = [overallCTE; obj.data(i).metricsCTE];
    overallHE = [overallHE; obj.data(i).metricsHE];

end