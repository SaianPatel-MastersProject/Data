%% Compare Drivers

obj = Plotting.multiPlotter();

%% Load Normal Data
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D3_R02.mat', true, [2:4]); % SM75_SP
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_07\2025_FYP04_07_D1_R02.mat', true, [2:4]); % SM75_BX
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_07\2025_FYP04_07_D1_R01.mat', true, [2:4]); % SM75_LZ


obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_31\2025_FYP03_31_D3_R02.mat', 4); % SM75_SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_07\2025_FYP04_07_D1_R02.mat', 4); % SM75_BX
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_07\2025_FYP04_07_D1_R01.mat', 4); % SM75_LZ

%% Get the averages of the metrics
avgMetricsCTE(1,:) = mean(obj.runData(1).metricsCTE,1);
avgMetricsCTE(2,:) = mean(obj.runData(2).metricsCTE,1);
avgMetricsCTE(3,:) = mean(obj.runData(3).metricsCTE,1);


avgMetricsSteer(1,:) = mean(obj.runData(1).metricsSteer,1);
avgMetricsSteer(2,:) = mean(obj.runData(2).metricsSteer,1);
avgMetricsSteer(3,:) = mean(obj.runData(3).metricsSteer,1);
%% Plot distributions of metrics
figure;
hold on
xline(avgMetricsCTE.TACTE(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsCTE.TACTE(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsCTE.TACTE(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('TACTE (m)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
xline(avgMetricsCTE.rCTE_pct(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsCTE.rCTE_pct(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsCTE.rCTE_pct(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('rCTE (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
xline(avgMetricsCTE.wCTE_pct(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsCTE.wCTE_pct(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsCTE.wCTE_pct(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('wCTE (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
xline(avgMetricsCTE.hCTE_pct(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsCTE.hCTE_pct(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsCTE.hCTE_pct(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('hCTE (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
xline(avgMetricsCTE.rRW(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsCTE.rRW(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsCTE.rRW(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('rRW')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})
%%
figure;
hold on
xline(avgMetricsSteer.MSteer(1) * 100, 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsSteer.MSteer(2) * 100, 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsSteer.MSteer(3) * 100, 'Color', '#EDB120', 'LineWidth', 2)
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
xline(avgMetricsSteer.dSteerMin(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsSteer.dSteerMin(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsSteer.dSteerMin(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('Minimum Steering Velocity')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
xline(avgMetricsSteer.dSteerMax(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsSteer.dSteerMax(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsSteer.dSteerMax(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('Maximum Steering Velocity')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
xline(avgMetricsSteer.steerL_pct(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsSteer.steerL_pct(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsSteer.steerL_pct(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('Left Steering (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
xline(avgMetricsSteer.steerR_pct(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsSteer.steerR_pct(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsSteer.steerR_pct(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('Right Steering (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})

%%
figure;
hold on
xline(avgMetricsSteer.steerC_pct(1), 'Color', '#0072BD', 'LineWidth', 2)
xline(avgMetricsSteer.steerC_pct(2), 'Color', '#D95319', 'LineWidth', 2)
xline(avgMetricsSteer.steerC_pct(3), 'Color', '#EDB120', 'LineWidth', 2)
xlabel('Centred Steering (%)')
ylabel('Frequency (%)')
legend({'SP', 'BX', 'LZ'})