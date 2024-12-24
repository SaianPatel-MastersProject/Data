function postProcessPE(matFilePath, bInterpolated, nPoints, interpMethod)

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
    columnNames = {'CTE', 'closestWaypointX', 'closestWaypointY', 'HeadingError'};
    nRows = size(runStruct.data, 1);
    arrayCTE = zeros([nRows, 1]);
    arrayClosestWaypointX = arrayCTE;
    arrayClosestWaypointY = arrayCTE;
    arrayHeadingError = arrayCTE;

    % Create an empty table with the specified column names
    dataPE = table('Size', [nRows, length(columnNames)], ...
        'VariableTypes', {'double', 'double', 'double', 'double'}, ...
        'VariableNames', columnNames);

    % Calculate the heading of the car
    dX = diff(runStruct.data.posX);
    dY = diff(runStruct.data.posY);
    psi = atan2(dY, dX);
    psi = [psi; psi(end)];

    % Loop through each logged point and compute CTE
    for i = 1:size(runStruct.data, 1)

        currentPoint = [runStruct.data.posX(i), runStruct.data.posY(i), psi(i)];
        [CTE, closestWaypoint, headingError] = PostProcessing.PE.fnCalculatePathError(currentPoint, AIW_Data);

        arrayCTE(i) = CTE;
        arrayClosestWaypointX(i) = closestWaypoint(1);
        arrayClosestWaypointY(i) = closestWaypoint(2);
        arrayHeadingError(i) = headingError;

    end

    dataPE.CTE = arrayCTE;
    dataPE.closestWaypointX = arrayClosestWaypointX;
    dataPE.closestWaypointY = arrayClosestWaypointY;
    dataPE.HeadingError = arrayHeadingError;

    % Write the CTE table as a layer
    % Set the .mat filename
    PE_matFilePath = strrep(matFilePath, '.mat', '_PE.mat');

    % Save the .mat
    save(PE_matFilePath, 'dataPE');



end