function lapSummary = calculateLapSummaryMetrics(runStruct)

    % Get the number of laps
    nLaps = size(runStruct.metadata.laps, 2);

    % Create an array which will be later a table
    lapSummaryArray = zeros([size(nLaps, 1), 11]);

    % Loop through each lap
    for i = 1:nLaps

        % Set the lap number
        lapNumber = i - 1;

        % Get the data for the lap
        lapData = runStruct.data(runStruct.data.lapNumber == lapNumber, :);

        % Create a lap time channel
        lapData.lapTime = lapData.time - lapData.time(1);

        % Create dSteerWheel channel
        lapData.dSteerAngle = [0; diff(lapData.steerAngle)];

        % Get the average steering wheel angle
        avgSteerAngle = mean(lapData.steerAngle);

        % Get the maximum steering wheel angles
        maxSteerAngle = max(lapData.steerAngle);

        % Get the minimum steering wheel angle
        minSteerAngle = min(lapData.steerAngle);

        % Get the average steering wheel angle
        avg_dSteerAngle = mean(lapData.dSteerAngle);

        % Get the maximum steering wheel angles
        max_dSteerAngle = max(lapData.dSteerAngle);

        % Get the minimum steering wheel angle
        min_dSteerAngle = min(lapData.dSteerAngle);

        % Populate the array
        lapSummaryArray(i, 1) = lapNumber;
        lapSummaryArray(i, 2) = avgSteerAngle;
        lapSummaryArray(i, 3) = maxSteerAngle;
        lapSummaryArray(i, 4) = minSteerAngle;
        lapSummaryArray(i, 5) = avg_dSteerAngle;
        lapSummaryArray(i, 6) = max_dSteerAngle;
        lapSummaryArray(i, 7) = min_dSteerAngle;



    end

    % Set the column names
    columnNames = {'lapNumber', 'avgSteerAngle', 'maxSteerAngle', 'minSteerAngle', 'avg_dSteerAngle', 'max_dSteerAngle', 'min_dSteerAngle'};

    % Save as a table
    lapSummary = table('Size', [size(lapSummaryArray,1), length(columnNames)], ...
        'VariableTypes', {'double', 'double', 'double', 'double', 'double', 'double', 'double'}, ...
        'VariableNames', columnNames);

    lapSummary.lapNumber = lapSummaryArray(:,1);
    lapSummary.avgSteerAngle = lapSummaryArray(:,2);
    lapSummary.maxSteerAngle = lapSummaryArray(:,3);
    lapSummary.minSteerAngle = lapSummaryArray(:,4);
    lapSummary.avg_dSteerAngle = lapSummaryArray(:,5);
    lapSummary.max_dSteerAngle = lapSummaryArray(:,6);
    lapSummary.min_dSteerAngle = lapSummaryArray(:,7);




end