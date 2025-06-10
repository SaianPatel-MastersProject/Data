%% Compare Generalisability Effect
objFFNN = Plotting.multiPlotter();

% Add training run
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', true, [2:10]); % SP k=-1.5
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_05\2025_FYP05_05_D1_R08.mat', true, []); % SM113
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_05\2025_FYP05_05_D3_R04.mat', true, []); % SM121

% Add reference lap
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', 10); % SP
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_05\2025_FYP05_05_D1_R08.mat', 4); % SM113
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_05\2025_FYP05_05_D3_R04.mat', 4); % SM121


% Overwrite the legend cell
objFFNN.plottingTools.legendCell = {'SP', 'SM113', 'SM121'};

%%
metricsCompFFNN = objFFNN.fnMetricsComparison(1, [2,3]);