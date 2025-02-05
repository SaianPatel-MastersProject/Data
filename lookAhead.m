%%
obj = Plotting.multiPlotter();

% Add training run
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', true, [2:31]);
obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D2_R04.mat', true, [2:4]);


% Add reference lap
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', 31); % Human
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D2_R04.mat', 4); % FFNN 39

%%

AIW_Table = Utilities.fnLoadAIW('SUZ');
[kappa, ~] = PostProcessing.PE.fnCalculateCurvature([AIW_Table.x, AIW_Table.y]);

%%
% Get look-ahead sigmoid
[dLookOverall, kappaSorted] = Utilities.fnLookAheadDistanceSigmoidCurvature(5, 30, 200, 0.01, kappa);

kappaAhead = zeros([size(obj.data(1).lapData, 1),1]);
idxAhead = zeros([size(obj.data(1).lapData, 1),1]);

% Loop through each of the curvature of the human lap and find the look
% ahead distance
for i = 1:size(obj.data(1).lapData, 1)

    kappaCurrent = obj.data(1).lapData.kappa(i);

    % dLook = Utilities.fnLookAheadDistanceSigmoidCurvature(5, 30, 200, 0.01, kappaCurrent);
    dLook = interp1(kappaSorted, dLookOverall, abs(kappaCurrent));

    % Find the point ahead which matches the look-ahead distance
    dataToEnd = obj.data(1).lapData(i:end, :);
    dx = [0; diff(dataToEnd.posX)];
    dy = [0; diff(dataToEnd.posY)];
    d = sqrt(dx.^2 + dy.^2);
    dRolling = cumsum(d);
    dDiff = abs(dRolling - dLook);
    [~, minIdx] = min(dDiff);
    % kappaAhead(i) = dataToEnd.kappa(minIdx);
    loopedIdx = Utilities.fnLoopArrayIndex(obj.data(1).lapData.kappa, i, minIdx);
    try
        kappaAhead(i) = obj.data(1).lapData.kappa(loopedIdx);
        idxAhead(i) = minIdx;

    catch ME

        kappaAhead(i) =99;

    end


end