%% Segmented track plot

%% Interpolate to common sLap
nLapsFFNN = size(objFFNN.data, 2);
sLapMax = 2375;
sLapCommon = (1:1:sLapMax)';
dataCTE = zeros([numel(sLapCommon), nLapsFFNN]);
X = dataCTE;
Y = X;

for i = 1:nLapsFFNN

    dataCTE(:,i) = interp1(objFFNN.data(i).lapData.lapDist, objFFNN.data(i).lapData.CTE, sLapCommon);
    X(:,i) = interp1(objFFNN.data(i).lapData.lapDist, objFFNN.data(i).lapData.posX, sLapCommon);
    Y(:,i) = interp1(objFFNN.data(i).lapData.lapDist, objFFNN.data(i).lapData.posY, sLapCommon);


end

% Find minimum of abs CTE at each point
[~, minIdx] = min(abs(dataCTE), [], 2);

%% plot
N = nLapsFFNN;
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
