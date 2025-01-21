%%

obj = Plotting.multiPlotter();

% Add training run
obj = obj.addRun('+ProcessedData/2024/FYP12_09/2024_FYP12_09_D4_R02.mat', true);
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP01_20\2025_FYP01_20_D2_R01.mat', true);

% Add reference lap
obj = obj.addLap('+ProcessedData/2024/FYP12_09/2024_FYP12_09_D4_R02.mat', 4); % Human
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP01_20\2025_FYP01_20_D2_R01.mat', 3); % FFNN 21
obj = obj.addLap('+ProcessedData/2024/FYP12_30/2025_FYP12_30_D5_R43.mat', 1); % PID (Optimised)