%% Comparing Human and FFNN steering with Curvature

%% Add data
obj = Plotting.multiPlotter();
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', true, [2:31]);
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_10\2025_FYP02_10_D1_R02.mat', true, [2:4]);

%% Plot scatters

figure;
hold on
grid on;
grid minor;
xlabel('Curvature (\kappa)')
ylabel('Steering Angle')
scatter(obj.runData(1).runData.kappa, obj.runData(1).runData.steerAngle, 'filled', '.', 'MarkerEdgeColor', 'b', 'SizeData', 4);
% scatter(obj.runData(2).runData.kappa, obj.runData(2).runData.steerAngle, 'filled', '.', 'MarkerEdgeColor', 'r','SizeData', 4);
legend({'Human Training Data', 'SM48'})