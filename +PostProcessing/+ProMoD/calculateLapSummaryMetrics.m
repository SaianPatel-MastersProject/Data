function lapSummary = calculateLapSummaryMetrics(runStruct)

    % Get the number of laps
    nLaps = size(runStruct.metadata.laps, 2);

    % Create an array which will be later a table
    lapSummaryArray = (zeros([size(nLaps, 1), 8]));

    % Create a cell for storing the runID
    lapSummaryCell = {};

    % Loop through each lap
    for i = 1:nLaps

        % Get the run ID
        runID = runStruct.metadata.runID;

        % Get the driver
        driverID = runStruct.metadata.driver;

        % Set the lap number
        lapNumber = runStruct.metadata.laps(i).lapNumber;

        % Set the lap type
        lapType = runStruct.metadata.laps(i).lapType;

        % Get the data for the lap
        lapData = runStruct.data(runStruct.data.lapNumber == lapNumber, :);

        % Create a lap time channel
        lapData.lapTime = lapData.time - lapData.time(1);

        % Create dSteerWheel channel
        lapData.dSteerAngle = [0; diff(lapData.steerAngle * 225 * 100)];

        % Get the average steering wheel angle
        avgSteerAngle = mean(lapData.steerAngle * 225);

        % Get the maximum steering wheel angles
        maxSteerAngle = max(lapData.steerAngle *225);

        % Get the minimum steering wheel angle
        minSteerAngle = min(lapData.steerAngle * 225);

        % Get the average steering wheel angle
        avg_dSteerAngle = mean(lapData.dSteerAngle);

        % Get the maximum steering wheel angles
        max_dSteerAngle = max(lapData.dSteerAngle);

        % Get the minimum steering wheel angle
        min_dSteerAngle = min(lapData.dSteerAngle);

        % Populate the array
        lapSummaryCell{i, 1} = runID;
        lapSummaryCell{i, 2} = driverID;
        lapSummaryArray(i, 1) = lapNumber;
        lapSummaryArray(i, 2) = lapType;
        lapSummaryArray(i, 3) = avgSteerAngle;
        lapSummaryArray(i, 4) = maxSteerAngle;
        lapSummaryArray(i, 5) = minSteerAngle;
        lapSummaryArray(i, 6) = avg_dSteerAngle;
        lapSummaryArray(i, 7) = max_dSteerAngle;
        lapSummaryArray(i, 8) = min_dSteerAngle;

    end

    % Set the column names
    columnNames = {'runID', 'driver', 'lapNumber', 'lapType', 'avgSteerAngle', 'maxSteerAngle', 'minSteerAngle', 'avg_dSteerAngle', 'max_dSteerAngle', 'min_dSteerAngle'};

    % Save as a table
    lapSummary = table('Size', [size(lapSummaryArray,1), length(columnNames)], ...
        'VariableTypes', {'string', 'string', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'}, ...
        'VariableNames', columnNames);

    lapSummary.runID = lapSummaryCell(:,1);
    lapSummary.driver = lapSummaryCell(:,2);
    lapSummary.lapNumber = lapSummaryArray(:,1);
    lapSummary.lapType = lapSummaryArray(:,2);
    lapSummary.avgSteerAngle = lapSummaryArray(:,3);
    lapSummary.maxSteerAngle = lapSummaryArray(:,4);
    lapSummary.minSteerAngle = lapSummaryArray(:,5);
    lapSummary.avg_dSteerAngle = lapSummaryArray(:,6);
    lapSummary.max_dSteerAngle = lapSummaryArray(:,7);
    lapSummary.min_dSteerAngle = lapSummaryArray(:,8);

    % Filter by flying laps only
    lapSummary = lapSummary(lapSummary.lapType == 1, :);

end