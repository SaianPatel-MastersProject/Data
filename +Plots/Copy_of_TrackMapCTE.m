%% Segmented track plot

%% Interpolate to common sLap
nLapsFFNN2 = [1, 11, 21];
sLapMax = 2375;
sLapCommon = (1:40:sLapMax)';
dataCTE = zeros([numel(sLapCommon), numel(nLapsFFNN2)]);
X = dataCTE;
Y = X;

for i = 1:numel(nLapsFFNN2)
    
    dataCTE(:,i) = interp1(objFFNN.data(nLapsFFNN2(i)).lapData.lapDist, objFFNN.data(nLapsFFNN2(i)).lapData.CTE, sLapCommon);
    X(:,i) = interp1(objFFNN.data(nLapsFFNN2(i)).lapData.lapDist, objFFNN.data(nLapsFFNN2(i)).lapData.posX, sLapCommon);
    Y(:,i) = interp1(objFFNN.data(nLapsFFNN2(i)).lapData.lapDist, objFFNN.data(nLapsFFNN2(i)).lapData.posY, sLapCommon);


end

% Find minimum of abs CTE at each point
[~, minIdx] = min(abs(dataCTE), [], 2);

%% plot
N = numel(nLapsFFNN2);
cmap = [linspace(0,1,N)', zeros(N,1), linspace(1,0,N)'];  % RGB values
colors = cmap(minIdx, :);

figure;
hold on
for j = 1:numel(sLapCommon)-1

    plot([X(j,1), X(j+1,1)], [Y(j,1), Y(j+1,1)], ...
     'Color', colors(j, :), 'LineWidth', 6);


end

colormap(cmap);
cb = colorbar;
cb.Ticks = linspace(0, 1, N);
cb.TickLabels = -10:1:10;  % adjust to match your setup values
cb.Label.String = 'Best Sensitivity Δ [%]';
