%% Corner TACTE

nRuns = size(objFFNN.data, 2);

% Read in nCorner sheet
nCornerTable = readtable("+Plotting\+nCorner\SUZ.xlsx", 'VariableNamingRule','preserve');
nCorners = 8;

% Initialise TACTE array
cornerCTE = zeros([nCorners, nRuns]);

%% Straights
startCTE = zeros([1,nRuns]);
endCTE = zeros([1,nRuns]);

for i = 1:nRuns

    ACTE = abs(objFFNN.data(i).lapData.CTE);
    lapDist = (objFFNN.data(i).lapData.lapDist);

    % Start
    sfDataStart = ACTE(lapDist < nCornerTable.sLapMin(1));
    startCTE(1,i) = mean(sfDataStart);
    % startCTE(1,i) = sum(sfDataStart) / (numel(sfDataStart) * 0.01);

    % End
    sfDataEnd = ACTE(lapDist > nCornerTable.sLapMin(nCorners));
    endCTE(1,i) = mean(sfDataEnd);
    % endCTE(1,i) = sum(sfDataEnd) / (numel(sfDataEnd) * 0.01);


end

%% Corners
for j = 1:nCorners

    for i = 1:nRuns

        ACTE = abs(objFFNN.data(i).lapData.CTE);
        lapDist = (objFFNN.data(i).lapData.lapDist);
    
        % Start
        cornerData = ACTE(and(lapDist > nCornerTable.sLapMin(j), lapDist < nCornerTable.sLapMax(j)));
        cornerCTE(j,i) = mean(cornerData);
        % cornerCTE(j,i) = sum(cornerData) / (numel(cornerData) * 0.01);



    end


end

%% Concatenate
lapCTE = [startCTE; cornerCTE; endCTE];

%% Plotting
figure;
z = (-10:1:10);
N = nRuns;
cmap = [linspace(0,1,N)', zeros(N,1), linspace(1,0,N)'];  % RGB values
colormap(cmap);
hold on
grid on
grid minor

for i = 1:size(lapCTE, 1)
    
    x = zeros([1, nRuns]);
    x(1,:) = i - 1;
    y = lapCTE(i, :);
    scatter(x, y, 72, z, 'filled')


end

set(gca,"TickLabelInterpreter",'latex')
xlabel('Corner', 'Interpreter','latex', 'FontSize', 24);
ylabel('TACTE $C$ [m/s]', 'Interpreter','latex', 'FontSize', 24);
cb = colorbar;
cb.Ticks = [-10, 0, 10];
cb.TickLabels = [-10, 0, 10];
cb.TickLabelInterpreter = 'latex';
cb.Label.Interpreter = 'latex';
cb.Label.String = 'Steering Sensitivity Delta $\Delta k$ [$\%$]';

%% Plot individual traces
for j = 1:nRuns

    plot((0:nCorners+1)', lapCTE(:,j), "Color", cmap(j,:), 'LineWidth',2);

end


%% Plot individual TACTE for lap
for j = 1:nRuns

    yAvg = sum(lapCTE(:,j)) / (numel(objFFNN.data(j).lapData.time) * 0.01);
    yline(yAvg, "Color", cmap(j,:), 'LineWidth',2);

end

%% Plot trained
for j = 1:nRuns

    if j == 1 || j == 11 || j == 21
        plot((0:nCorners+1)', lapCTE(:,j), "Color", cmap(j,:), 'LineWidth',2);
    end

end