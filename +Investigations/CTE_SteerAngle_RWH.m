%%
obj = Plotting.multiPlotter();

% Add training run
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', true, [2:10]); % SP BAR

% Add reference lap
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP04_14\2025_FYP04_14_D7_R03.mat', 10); % SP BAR

%%
figure;
grid on;
grid minor;
dSteer = [0; diff(obj.runData(1).runData.steerAngle .* 225)] ./ 0.01;
scatter(dSteer, obj.runData(1).runData.CTE);
xlabel('Steering Velocity')
ylabel('CTE')

%%
figure;
grid on;
grid minor;
scatter(obj.runData(1).runData.steerAngle, obj.runData(1).runData.CTE);
xlabel('Steering Angle')
ylabel('CTE')

%% 
figure;
grid on;
grid minor;

%%
xIdx = and(dSteer > -20, dSteer < 20);
yIdx = and(abs(dSteer) > 20, abs(dSteer) < 40);
zIdx = and(abs(dSteer) > 40, abs(dSteer) < 60);

%%
scatter(dSteer(xIdx), obj.runData(1).runData.CTE(xIdx));
xlabel('Steering Velocity')
ylabel('CTE')


%%
figure;
hold on
boxplot(obj.runData(1).runData.HeadingError(zIdx), "Normalization", "percentage");
histogram(obj.runData(1).runData.HeadingError(yIdx), "Normalization", "percentage");
histogram(obj.runData(1).runData.HeadingError(xIdx), "Normalization", "percentage");

%%
figure;
boxplot(obj.runData(1).runData.CTE(xIdx));

figure;
boxplot(obj.runData(1).runData.CTE(yIdx));

figure;
boxplot(obj.runData(1).runData.CTE(zIdx));