%% Compare Drivers

obj = Plotting.multiPlotter();

%% Load Normal Data
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', true, [2:31]); % SP
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08.mat', true, [1:21]); % BX
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05.mat', true, [2:20]); % LZ
% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D5_R02.mat', true, [2:4]); % PID

obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', 31); % SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08.mat', 21); % BX
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05.mat', 20); % LZ
% obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D5_R02.mat', 4); % PID

%% Load Average Laps
objAvg = Plotting.multiPlotter();
objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02_AvgLap.mat', true, []); % SP
objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08_AvgLap.mat', true, []); % BX
objAvg = objAvg.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05_AvgLap.mat', true, []); % LZ


objAvg = objAvg.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02_AvgLap.mat'); % SP
objAvg = objAvg.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R08_AvgLap.mat'); % BX
objAvg = objAvg.addAverageLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D5_R05_AvgLap.mat'); % LZ

%% Get Avg Tables
avgMetricsCTE(1,:) = mean(obj.runData(1).metricsCTE,1);
avgMetricsCTE(2,:) = mean(obj.runData(2).metricsCTE,1);
avgMetricsCTE(3,:) = mean(obj.runData(3).metricsCTE,1);
avgMetricsCTE(4,:) = mean(obj.runData(4).metricsCTE,1);

avgMetricsSteer(1,:) = mean(obj.runData(1).metricsSteer,1);
avgMetricsSteer(2,:) = mean(obj.runData(2).metricsSteer,1);
avgMetricsSteer(3,:) = mean(obj.runData(3).metricsSteer,1);
avgMetricsSteer(4,:) = mean(obj.runData(4).metricsSteer,1);

%% Plot distributions of metrics
figure;
hold on
histogram(obj.runData(1).metricsCTE.TACTE, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsCTE.TACTE, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsCTE.TACTE, 6, "Normalization", "percentage");
xlabel('TACTE (m)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).metricsCTE.rCTE_pct, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsCTE.rCTE_pct, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsCTE.rCTE_pct, 6, "Normalization", "percentage");
xlabel('rCTE (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).metricsCTE.wCTE_pct, 6,"Normalization", "percentage");
histogram(obj.runData(2).metricsCTE.wCTE_pct, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsCTE.wCTE_pct, 6, "Normalization", "percentage");
xlabel('wCTE (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).metricsCTE.hCTE_pct, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsCTE.hCTE_pct, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsCTE.hCTE_pct, 6, "Normalization", "percentage");
xlabel('hCTE (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).metricsCTE.rRW, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsCTE.rRW, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsCTE.rRW, 6, "Normalization", "percentage");
xlabel('rRW')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})
%%
figure;
hold on
histogram(obj.runData(1).metricsSteer.MSteer, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsSteer.MSteer, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsSteer.MSteer, 6, "Normalization", "percentage");
xlabel('MSteer')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).runData.steerAngle * 225, 24, "Normalization", "percentage");
histogram(obj.runData(2).runData.steerAngle * 225, 24, "Normalization", "percentage");
histogram(obj.runData(3).runData.steerAngle * 225, 24, "Normalization", "percentage");
xlabel('Steering Angle (deg)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).metricsSteer.dSteerMin, 6,"Normalization", "percentage");
histogram(obj.runData(2).metricsSteer.dSteerMin, 6,"Normalization", "percentage");
histogram(obj.runData(3).metricsSteer.dSteerMin, 6, "Normalization", "percentage");
xlabel('Minimum Steering Velocity')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).metricsSteer.dSteerMax, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsSteer.dSteerMax, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsSteer.dSteerMax, 6, "Normalization", "percentage");
xlabel('Maximum Steering Velocity')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).metricsSteer.steerL_pct, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsSteer.steerL_pct, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsSteer.steerL_pct, 6, "Normalization", "percentage");
xlabel('Left Steering (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).metricsSteer.steerR_pct, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsSteer.steerR_pct, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsSteer.steerR_pct, 6, "Normalization", "percentage");
xlabel('Right Steering (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
histogram(obj.runData(1).metricsSteer.steerC_pct, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsSteer.steerC_pct, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsSteer.steerC_pct, 6, "Normalization", "percentage");
xlabel('Centred Steering (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%% Plot distributions of metrics
figure;
hold on
histogram(obj.runData(1).metricsCTE.LapTime, 6, "Normalization", "percentage");
histogram(obj.runData(2).metricsCTE.LapTime, 6, "Normalization", "percentage");
histogram(obj.runData(3).metricsCTE.LapTime, 6, "Normalization", "percentage");
xlabel('Lap Time (s)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})