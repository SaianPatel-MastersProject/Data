%%

obj = Plotting.multiPlotter();


%% SUZ
% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_10\2025_FYP02_10_D1_R02.mat', true, [2:4]);
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', true, [2:31]);
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08.mat', true, [1:21]); % BX
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05.mat', true, [2:20]); % LZ

% obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_10\2025_FYP02_10_D1_R02.mat', 4); % FFNN 47
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', 31); % Human
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08.mat', 21); % FFNN 47
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05.mat', 20); % FFNN 47
%% MGL
% obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_10\2025_FYP02_10_D2_R03.mat', 1);
% obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_24\2025_FYP03_24_D5_R03.mat', 6);
% 
% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_10\2025_FYP02_10_D2_R03.mat', true, []);
% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_24\2025_FYP03_24_D5_R03.mat', true, []);

%% Compute CI for Human
humanMean = mean(obj.runData(2).metricsCTE.TACTE);
humanStd = std(obj.runData(2).metricsCTE.TACTE);
nHumanSamples = length(obj.runData(2).metricsCTE.TACTE);

ci_upper = humanMean + 1.96 * humanStd / nHumanSamples;
ci_lower = humanMean - 1.96 * humanStd / nHumanSamples;


%%
maxVal = humanMean + humanStd;

%%
[H, P] = ttest(obj.runData(2).metricsCTE.rCTE_pct, mean(obj.runData(1).metricsCTE.rCTE_pct));

%%
avgMetricsCTE(1,:) = mean(obj.runData(1).metricsCTE,1);
avgMetricsCTE(2,:) = mean(obj.runData(2).metricsCTE,1);
avgMetricsCTE(3,:) = mean(obj.runData(3).metricsCTE,1);

avgMetricsSteer(1,:) = mean(obj.runData(1).metricsSteer,1);
avgMetricsSteer(2,:) = mean(obj.runData(2).metricsSteer,1);
avgMetricsSteer(3,:) = mean(obj.runData(3).metricsSteer,1);
