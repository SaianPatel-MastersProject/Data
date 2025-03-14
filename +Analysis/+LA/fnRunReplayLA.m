%% Wrapper for fnReplayLA
function fnRunReplayLA(matFilePath, lapNumber)


    %% Data Loading
    % Read in a run .mat file
    load(matFilePath);
    
    % Get the runID
    runID = runStruct.metadata.runID;
    
    % Get the track
    trackID = runStruct.metadata.track;
    
    % Load the associated AIW
    AIW_Table = Utilities.fnLoadAIW(trackID);
    AIW_Data = [AIW_Table.x, AIW_Table.y];
    
    % Get the curvature, kappa
    [kappa, ~] = PostProcessing.PE.fnCalculateCurvature([AIW_Table.x, AIW_Table.y]);
    
    % Interpolate
    spacing = 0.1;
    method = 'spline';
    
    xInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.x, spacing, method);
    yInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.y, spacing, method);
    kappaInterp = Utilities.fnInterpolateByDist(AIW_Data, kappa, spacing, method);
    
    AIW_Data = [xInterp, yInterp];
    
    % Load Associated Layers
    runStruct = Utilities.fnLoadLayer(runStruct, 'PE');
    runStruct = Utilities.fnLoadLayer(runStruct, 'KAP');
    
    % Only keep the specified lap
    lapData = runStruct.data(runStruct.data.lapNumber == lapNumber, :);

    %% LA Calculations

    % Define the sigmoid
    [dLookOverall, kappaSorted] = Utilities.fnLookAheadDistanceSigmoidCurvature(6, 30, 200, 0.01, kappaInterp);

    % Initialise dataLA
    dataLA = zeros([size(lapData, 1), 4]);
    dataLA(:,1) = lapData.posX;
    dataLA(:,2) = lapData.posY;

    % Loop through the data
    for i = 1:size(lapData, 1)

        % Find look-ahead index
        dLookAhead = interp1(kappaSorted, dLookOverall, abs(lapData.kappa(i)));
        iLookAhead = round(dLookAhead/0.1);

        % Set current car point
        xV = lapData.posX(i);
        yV = lapData.posY(i);
        
        % Find nearest AIW waypoint using Euclidean distance
        d = sqrt((AIW_Data(:,1) - xV).^2 + (AIW_Data(:,2) -yV).^2);
        [~, closestWaypointIdx] = min(d);

        % Look ahead in x-y on the AIW Data
        dataLA(i,3) = Utilities.fnGetLookAheadValues(AIW_Data(:,1), closestWaypointIdx, iLookAhead, 1);
        dataLA(i,4) = Utilities.fnGetLookAheadValues(AIW_Data(:,2), closestWaypointIdx, iLookAhead, 1);


    end

    % Call the LA Replay
    Analysis.LA.fnReplayLA(dataLA, AIW_Data);





end