%% Steering Deadzone
figure;
hold on
scatter(obj.runData(1).runData.CTE, obj.runData(1).runData.steerAngle, 'filled');
scatter(obj.runData(2).runData.CTE, obj.runData(2).runData.steerAngle, 'filled');
scatter(obj.runData(3).runData.CTE, obj.runData(3).runData.steerAngle, 'filled');
%% Scatter
figure;
hold on
scatter(obj.runData(1).runData.CTE, obj.runData(1).runData.dSteerAngle, 'filled');
scatter(obj.runData(2).runData.CTE, obj.runData(2).runData.dSteerAngle, 'filled');
scatter(obj.runData(3).runData.CTE, obj.runData(3).runData.dSteerAngle, 'filled');

%% Distribution
figure;
hold on
histogram(obj.runData(1).runData.dSteerAngle(abs(obj.runData(1).runData.CTE) < 0.2), "Normalization", "percentage");
histogram(obj.runData(2).runData.dSteerAngle(abs(obj.runData(2).runData.CTE) < 0.2), "Normalization", "percentage");
histogram(obj.runData(3).runData.dSteerAngle(abs(obj.runData(3).runData.CTE) < 0.2), "Normalization", "percentage");

%% Violin
figure;
hold on
violinplot(obj.runData(1).runData.dSteerAngle(abs(obj.runData(1).runData.CTE) < 0.2));
violinplot(obj.runData(2).runData.dSteerAngle(abs(obj.runData(2).runData.CTE) < 0.2));
violinplot(obj.runData(3).runData.dSteerAngle(abs(obj.runData(3).runData.CTE) < 0.2));

%% Find when CTE starts decreasing
figure;
hold on

straightGate = abs(obj.runData(1).runData.lapDist) < 400;
straightData = obj.runData(1).runData(straightGate, :);
dCTE_maxima = abs([0; diff(straightData.CTE)]./0.01) < 0.05;
cteDecrData = straightData(dCTE_maxima, :);
meanC = mean(abs(cteDecrData.CTE));
stdC = std(cteDecrData.CTE);

scatter(cteDecrData.CTE, cteDecrData.steerAngle, 'filled')

straightGate = abs(obj.runData(2).runData.lapDist) < 400;
straightData = obj.runData(2).runData(straightGate, :);
dCTE_maxima = abs([0; diff(straightData.CTE)]./0.01) < 0.05;
cteDecrData = straightData(dCTE_maxima, :);
meanC2 = mean(abs(cteDecrData.CTE));
stdC2 = std(cteDecrData.CTE);

scatter(cteDecrData.CTE, cteDecrData.steerAngle, 'filled')

straightGate = abs(obj.runData(3).runData.lapDist) < 400;
straightData = obj.runData(3).runData(straightGate, :);
dCTE_maxima = abs([0; diff(straightData.CTE)]./0.01) < 0.05;
cteDecrData = straightData(dCTE_maxima, :);
meanC3 = mean(abs(cteDecrData.CTE));
stdC3 = std(cteDecrData.CTE);

scatter(cteDecrData.CTE, cteDecrData.steerAngle, 'filled')

straightGate = abs(obj.runData(4).runData.lapDist) < 400;
straightData = obj.runData(4).runData(straightGate, :);
dCTE_maxima = abs([0; diff(straightData.CTE)]./0.01) < 0.05;
cteDecrData = straightData(dCTE_maxima, :);
meanC4 = mean(abs(cteDecrData.CTE));
stdC4 = std(cteDecrData.CTE);

scatter(cteDecrData.CTE, cteDecrData.steerAngle, 'filled')

