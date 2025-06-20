%% Plotting Script - Iteration 105
obj = Plotting.multiPlotter();

% Add training run
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R05.mat', true, [2:8]); % SP k=-1.5
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_28\2025_FYP04_28_D7_R02.mat', true, [1:11]); % SP k =-1.425
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_28\2025_FYP04_28_D7_R04.mat', true, [1:11]); % SP k =-1.575



% Add reference lap
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R05.mat', 8); % SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_28\2025_FYP04_28_D7_R02.mat', 11); % SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_28\2025_FYP04_28_D7_R04.mat', 11); % SP

% Overwrite the legend cell
obj.plottingTools.legendCell = {'Baseline', '-5%', '+5%'};
%% Avg Laps
objAvg = Plotting.multiPlotter();

% Add training run
objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R05_AvgLap.mat', true, []); % SP k=-1.5
objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_28\2025_FYP04_28_D7_R02_AvgLap.mat', true, []); % SP k =-1.425
objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_28\2025_FYP04_28_D7_R04_AvgLap.mat', true, []); % SP k =-1.575

% Add reference lap
objAvg = objAvg.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R05_AvgLap.mat'); % SP
objAvg = objAvg.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_28\2025_FYP04_28_D7_R02_AvgLap.mat'); % SP
objAvg = objAvg.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_28\2025_FYP04_28_D7_R04_AvgLap.mat'); % SP

% Overwrite the legend cell
objAvg.plottingTools.legendCell = {'Baseline', '-5%', '+5%'};

%% FFNN Laps - SM130
objFFNN = Plotting.multiPlotter();

% Add training run
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D2_R06.mat', true, [2:4]); % SP k=-1.5
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D2_R07.mat', true, [2:4]); % SP k =-1.425
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D2_R08.mat', true, [2:4]); % SP k =-1.575
% objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D2_R09.mat', true, [2:4]); % SP k =-1.545
% objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D3_R11.mat', true, [2:4]); % SP k =-1.455
% objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D3_R12.mat', true, [2:4]); % SP k =-1.65

% Add reference lap
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D2_R06.mat', 4); 
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D2_R07.mat', 4); 
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D2_R08.mat', 4); 
% objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D2_R09.mat', 4); 
% objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D3_R11.mat', 4); 
% objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_12\2025_FYP05_12_D3_R12.mat', 4); 

% Overwrite the legend cell
objFFNN.plottingTools.legendCell = {'Baseline', '-5%', '+5%'};

%% Stats Test & Metrics
metricsComp = obj.fnMetricsComparison(1, [2, 3]);
metricsCompAvg = objAvg.fnMetricsComparison(1, [2, 3]);
metricsCompFFNN = objFFNN.fnMetricsComparison(1, [2, 3]);



%%%%%%%% Plotting Commands
%% Set plot colours
% Human as blue
% FFNN as red
obj = obj.addLapsColours({'#0077FF', '#FF0000', '#008000'});
%% Plot the racing line
obj.plotRacingLine(true);
obj.plotLineDistribution(1, true, [1,2,3])
%% Plot steering angle with errors
obj.plotErrorsWithSteering();

%% Plot steering and its derivatives
obj.plotDerivativesSteeringAngle(true);

%% Plot variability relative to the human data
obj.plotEnvelope(1, 'CTE', true);
obj.plotEnvelope(1, 'HeadingError', true);
obj.plotEnvelope(1, 'steerAngle', true);

%% Plot variability relative of the FFNN
obj.plotEnvelope(2, 'CTE', false);
obj.plotEnvelope(2, 'HeadingError', false);
obj.plotEnvelope(2, 'steerAngle', false);

%% Plot PSPectrum
obj.plotPSpectrum('steerAngle', 'Run')
xlim([0, 5])
obj.plotPSpectrum('dSteerAngle', 'Run')
xlim([0, 5])
obj.plotPSpectrum('CTE', 'Run')
xlim([0, 5])

%% Plot Violins
obj.plotRunViolins();
obj.plotGroupedMetrics();

%% Plot TF Estimate
obj.plotTF('CTE', 'steerAngle', 'Lap', false);
obj.plotTF('kappa', 'steerAngle', 'Lap', false);

