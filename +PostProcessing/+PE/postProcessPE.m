function postProcessPE(matFilePath, interpType, interpParam, interpMethod)

    % Read in a run .mat file
    load(matFilePath);

    try

        % Directly load AIW using look-up
        AIW_Table = Utilities.fnLoadAIW(runStruct.metadata.track);

    catch

        error('Could not find a corresponding AIW.')

    end

    AIW_Data = [AIW_Table.x, AIW_Table.y];

    switch interpType

        case 'Distance'

            xInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.x, interpParam, interpMethod);
            yInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.y, interpParam, interpMethod);
            AIW_Data = [xInterp, yInterp];

        case 'Points'

            xInterp = Utilities.fnInterpolateByN(AIW_Data, AIW_Table.x, interpParam, interpMethod);
            yInterp = Utilities.fnInterpolateByN(AIW_Data, AIW_Table.y, interpParam, interpMethod);
            AIW_Data = [xInterp, yInterp];

    end

    % Create a table for the CTE data
    % Define the column names
    columnNames = {'CTE_CoG', 'CTE', 'closestWaypointX', 'closestWaypointY', 'HeadingError_CoG', 'HeadingError'};
    nRows = size(runStruct.data, 1);
    arrayCTE = zeros([nRows, 1]);
    arrayCTE_LA = arrayCTE;
    arrayClosestWaypointX = arrayCTE;
    arrayClosestWaypointY = arrayCTE;
    arrayHeadingError = arrayCTE;
    arrayHeadingError_LA = arrayCTE;

    % Create an empty table with the specified column names
    dataPE = table('Size', [nRows, length(columnNames)], ...
        'VariableTypes', {'double', 'double', 'double', 'double', 'double', 'double'}, ...
        'VariableNames', columnNames);

    % Calculate the heading of the car
    dX = diff(runStruct.data.posX);
    dY = diff(runStruct.data.posY);
    psi = atan2(dY, dX);
    psi = [psi; psi(end)];

    % Loop through each logged point and compute CTE
    for i = 1:size(runStruct.data, 1)

        currentPoint = [runStruct.data.posX(i), runStruct.data.posY(i), psi(i)];
        [CTE_CoG, closestWaypoint, headingError_CoG] = PostProcessing.PE.fnCalculatePathError(currentPoint, AIW_Data);

        % Get CTE and HE at 3m ahead
        [CTE_LA, ~, headingError_LA] = PostProcessing.PE.fnCalculatePathErrorLA(currentPoint, AIW_Data, 30);

        arrayCTE(i) = CTE_CoG;
        arrayCTE_LA(i) = CTE_LA;
        arrayClosestWaypointX(i) = closestWaypoint(1);
        arrayClosestWaypointY(i) = closestWaypoint(2);
        arrayHeadingError(i) = headingError_CoG;
        arrayHeadingError_LA(i) = headingError_LA;

    end

    dataPE.CTE_CoG = arrayCTE;
    dataPE.CTE = arrayCTE_LA;
    dataPE.closestWaypointX = arrayClosestWaypointX;
    dataPE.closestWaypointY = arrayClosestWaypointY;
    dataPE.HeadingError_CoG = arrayHeadingError;
    dataPE.HeadingError = arrayHeadingError_LA;

    % Write the CTE table as a layer
    % Set the .mat filename
    PE_matFilePath = strrep(matFilePath, '.mat', '_PE.mat');

    % Save the .mat
    save(PE_matFilePath, 'dataPE');



end