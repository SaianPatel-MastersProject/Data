function postProcessKAP(matFilePath, bInterpolated, nPoints, interpMethod)

    % Read in a run .mat file
    load(matFilePath);

    switch runStruct.metadata.track
        case 'Arrow Speedway'

            AIW_Table = readtable('+PostProcessing\+CTE\Arrow_IP.csv');

        case '2kFlat'

            AIW_Table = readtable('+PostProcessing\+CTE\2kFlat.csv');

        otherwise

            % Track not recognised
            return;

    end

    AIW_Data = [AIW_Table.x, AIW_Table.y];

    % Calculate Curvature
    [kappa, rCurvature] = PostProcessing.PE.fnCalculateCurvature(AIW_Data);

    if bInterpolated

        dBetweenPoints = (sqrt(diff(AIW_Data(:,1)).^2 + diff(AIW_Data(:,2)).^2));
        rollingDistance = [0; cumsum(dBetweenPoints)];
        dNew = (linspace(0, rollingDistance(end), nPoints))';
        xInterp = interp1(rollingDistance, AIW_Data(:,1), dNew, interpMethod);
        yInterp = interp1(rollingDistance, AIW_Data(:,2), dNew, interpMethod);
        kappaInterp = interp1(rollingDistance, kappa, dNew, interpMethod);
        rCurvatureInterp = interp1(rollingDistance, rCurvature, dNew, interpMethod);
        AIW_Data = [xInterp, yInterp, kappaInterp, rCurvatureInterp];

    end

    % Set nRows
    nRows = size(runStruct.data, 1);

    % Define an array to store closest kappa
    closestKappa = zeros([nRows, 1]);
    closestRCurv = zeros([nRows, 1]);

    % Loop through each logged point and get closest kappa and rCurvature
    for i = 1:size(runStruct.data, 1)

        xV = runStruct.data.posX(i);
        yV = runStruct.data.posY(i);

        % Find nearest AIW waypoint using Euclidean distance
        d = sqrt((AIW_Data(:,1) - xV).^2 + (AIW_Data(:,2) -yV).^2);
        [~, closestWaypointIdx] = min(d);

        % Select closest kappa and rCurvature
        closestKappa(i) = AIW_Data(closestWaypointIdx, 3);
        closestRCurv(i) = AIW_Data(closestWaypointIdx, 4);

    end

    % Store as an array
    dataKAP = [closestKappa, closestRCurv];

    % Define the column names
    columnNames = {'kappa', 'rCurvature'};

    % Save as a table
    dataKAP = array2table(dataKAP, 'VariableNames', columnNames);

    % Write the CTE table as a layer
    % Set the .mat filename
    KAP_matFilePath = strrep(matFilePath, '.mat', '_KAP.mat');

    % Save the .mat
    save(KAP_matFilePath, 'dataKAP');



end