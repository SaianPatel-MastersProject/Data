%% Combined PSD
objC = Plotting.multiPlotter();

objC = objC.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', true, [2:31]); % SP
objC = objC.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D6_R01.mat', true, [2:4]); % SP k=-1.5

objC = objC.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08.mat', true, [1:21]); % BX
objC = objC.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D3_R09.mat', true, [2:4]); % SP k =-1.425

objC = objC.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05.mat', true, [2:20]); % LZ
objC = objC.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D3_R10.mat', true, [2:4]); % SP k =-1.575

% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D5_R02.mat', true, [2:4]); % PID




objC = objC.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', 31); % SP
objC = objC.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D6_R01.mat', 4); 

objC = objC.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08.mat', 21); % BX
objC = objC.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D3_R09.mat', 4); 

objC = objC.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05.mat', 20); % LZ
objC = objC.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D3_R10.mat', 4);

% obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D5_R02.mat', 4); % PID


% Set legend
objC.plottingTools.legendCell = {'Driver 1', 'Driver Model 1', 'Driver 2', 'Driver Model 2', 'Driver 3', 'Driver Model 3'};