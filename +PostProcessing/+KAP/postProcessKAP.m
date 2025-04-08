function postProcessKAP(matFilePath, interpType, interpParam, interpMethod)

    % Read in a run .mat file
    load(matFilePath);

    try

        % Directly load AIW using look-up
        AIW_Table = Utilities.fnLoadAIW(runStruct.metadata.track);

    catch

        error('Could not find a corresponding AIW.')

    end

    AIW_Data = [AIW_Table.x, AIW_Table.y];

    % Calculate Curvature
    [kappa, rCurvature] = PostProcessing.PE.fnCalculateCurvature(AIW_Data);

    switch interpType
        case 'Distance'

            xInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.x, interpParam, interpMethod);
            yInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.y, interpParam, interpMethod);
            kappaInterp = Utilities.fnInterpolateByDist(AIW_Data, kappa, interpParam, interpMethod);
            rCurvatureInterp = Utilities.fnInterpolateByDist(AIW_Data, rCurvature, interpParam, interpMethod);
            AIW_Data = [xInterp, yInterp, kappaInterp, rCurvatureInterp];

        case 'Points'

            xInterp = Utilities.fnInterpolateByN(AIW_Data, AIW_Table.x, interpParam, interpMethod);
            yInterp = Utilities.fnInterpolateByN(AIW_Data, AIW_Table.y, interpParam, interpMethod);
            kappaInterp = Utilities.fnInterpolateByN(AIW_Data, kappa, interpParam, interpMethod);
            rCurvatureInterp = Utilities.fnInterpolateByN(AIW_Data, rCurvature, interpParam, interpMethod);
            AIW_Data = [xInterp, yInterp, kappaInterp, rCurvatureInterp];

    end

    % Set nRows
    nRows = size(runStruct.data, 1);

    % Define an array to store closest kappa
    closestKappa = zeros([nRows, 1]);
    closestRCurv = zeros([nRows, 1]);

    % Define an array to store LA kappa
    lookAheadKappa = zeros([nRows, 1]);

    % Define the sigmoid
    % Get look-ahead sigmoid
    [dLookOverall, kappaSorted] = Utilities.fnLookAheadDistanceSigmoidCurvature(6, 30, 200, 0.01, kappaInterp);

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

        % Get LA Kappa
        dLookAhead = interp1(kappaSorted, dLookOverall, abs(closestKappa(i)));
        iLookAhead = round(dLookAhead/0.1);

        % Look Ahead in Kappa
        lookAheadKappa(i) = Utilities.fnGetLookAheadValues(kappaInterp, closestWaypointIdx, iLookAhead, 1);

    end

    % Store as an array
    dataKAP = [closestKappa, closestRCurv, lookAheadKappa];

    % Define the column names
    columnNames = {'kappa', 'rCurvature', 'lookAhead1'};

    % Save as a table
    dataKAP = array2table(dataKAP, 'VariableNames', columnNames);

    % Write the CTE table as a layer
    % Set the .mat filename
    KAP_matFilePath = strrep(matFilePath, '.mat', '_KAP.mat');

    % Save the .mat
    save(KAP_matFilePath, 'dataKAP');



end