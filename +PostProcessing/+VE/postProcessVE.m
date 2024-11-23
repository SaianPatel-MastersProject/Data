function postProcessVE(matFilePath, bInterpolated, nPoints, interpMethod)

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
    columnNames = {'vError', 'refVel', 'rCurvature'};

    % Create an empty table with the specified column names
    dataVE = table('Size', [0, length(columnNames)], ...
        'VariableTypes', {'double', 'double', 'double'}, ...
        'VariableNames', columnNames);

    % Set vMax and vMin
    vMax = 80;
    vMin = 40;

    % Loop through each logged point and compute CTE
    for i = 1:size(runStruct.data, 1)

        currentPosition = [runStruct.data.posX(i), runStruct.data.posY(i)];
        currentVel = runStruct.data.speed(i);
        [vError, refVel, rCurvCurrent] = PostProcessing.VE.calculateVelocityError(currentPosition, currentVel, AIW_Data, vMax, vMin);

        dataVE.vError(i) = vError;
        dataVE.refVel(i) = refVel;
        dataVE.rCurvature(i) = rCurvCurrent;

    end

    % Write the CTE table as a layer
    % Set the .mat filename
    VE_matFilePath = strrep(matFilePath, '.mat', '_VE.mat');

    % Save the .mat
    save(VE_matFilePath, 'dataVE');



end