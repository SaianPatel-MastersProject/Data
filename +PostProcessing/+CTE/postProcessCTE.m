function postProcessCTE(matFilePath, bInterpolated, nPoints, interpMethod)

    % Read in a run .mat file
    load(matFilePath);

    switch runStruct.metadata.track
        case 'Arrow Speedway'

            AIW_Table = readtable('+PostProcessing\+CTE\Arrow.csv');

        case '2kFlat'

            AIW_Table = readtable('+PostProcessing\+CTE\2kFlat.csv');

        otherwise

            % Track not recognised
            return;

    end

    AIW_Data = [AIW_Table.x, AIW_Table.y];

    if bInterpolated

        dBetweenPoints = (sqrt(diff(AIW_Data(:,1)).^2 + diff(AIW_Data(:,2)).^2));
        rollingDistance = [0; cumsum(dBetweenPoints)];
        dNew = (linspace(0, rollingDistance(end), nPoints))';
        xInterp = interp1(rollingDistance, AIW_Data(:,1), dNew, interpMethod);
        yInterp = interp1(rollingDistance, AIW_Data(:,2), dNew, interpMethod);
        AIW_Data = [xInterp, yInterp];

    end

    % Create a table for the CTE data
    % Define the column names
    columnNames = {'CTE', 'closestWaypointX', 'closestWaypointY'};
    nRows = size(runStruct.data, 1);
    arrayCTE = zeros([nRows, 1]);
    arrayClosestWaypointX = arrayCTE;
    arrayClosestWaypointY = arrayCTE;

    % Create an empty table with the specified column names
    dataCTE = table('Size', [nRows, length(columnNames)], ...
        'VariableTypes', {'double', 'double', 'double'}, ...
        'VariableNames', columnNames);

    % Loop through each logged point and compute CTE
    for i = 1:size(runStruct.data, 1)

        currentPoint = [runStruct.data.posX(i), runStruct.data.posY(i)];
        [CTE, closestWaypoint] = PostProcessing.CTE.calculateCTE(currentPoint, AIW_Data);

        % dataCTE.CTE(i) = CTE;
        % dataCTE.closestWaypointX(i) = closestWaypoint(1);
        % dataCTE.closestWaypointY(i) = closestWaypoint(2);
        arrayCTE(i) = CTE;
        arrayClosestWaypointX(i) = closestWaypoint(1);
        arrayClosestWaypointY(i) = closestWaypoint(2);

    end

    dataCTE.CTE = arrayCTE;
    dataCTE.closestWaypointX = arrayClosestWaypointX;
    dataCTE.closestWaypointY = arrayClosestWaypointY;

    % Write the CTE table as a layer
    % Set the .mat filename
    CTE_matFilePath = strrep(matFilePath, '.mat', '_CTE.mat');

    % Save the .mat
    save(CTE_matFilePath, 'dataCTE');



end