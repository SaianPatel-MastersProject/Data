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
        maxSteerAngle_L = max(lapData.steerAngle(lapData.steerAngle < 0));
        maxSteerAngle_R = max(lapData.steerAngle(lapData.steerAngle > 0));

        % Get the minimum steering wheel angle
        minSteerAngle_L = max(lapData.steerAngle(lapData.steerAngle < 0));
        minSteerAngle_R = max(lapData.steerAngle(lapData.steerAngle > 0));

        % Get the average steering wheel angle
        avg_dSteerAngle = mean(lapData.dSteerAngle);

        % Get the maximum steering wheel angles
        max_dSteerAngle_L = max(lapData.dSteerAngle(lapData.steerAngle < 0));
        max_dSteerAngle_R = max(lapData.dSteerAngle(lapData.steerAngle > 0));

        % Get the minimum steering wheel angle
        min_dSteerAngle_L = min(lapData.dSteerAngle(lapData.steerAngle < 0));
        min_dSteerAngle_R = min(lapData.dSteerAngle(lapData.steerAngle > 0));

        % Populate the array
        lapSummaryArray(i, 1) = lapNumber;
        lapSummaryArray(i, 2) = avgSteerAngle;
        lapSummaryArray(i, 3) = maxSteerAngle_L;
        lapSummaryArray(i, 4) = maxSteerAngle_R;
        lapSummaryArray(i, 5) = minSteerAngle_L;
        lapSummaryArray(i, 6) = minSteerAngle_R;
        lapSummaryArray(i, 7) = avg_dSteerAngle;
        lapSummaryArray(i, 8) = max_dSteerAngle_L;
        lapSummaryArray(i, 9) = max_dSteerAngle_R;
        lapSummaryArray(i, 10) = min_dSteerAngle_L;
        lapSummaryArray(i, 11) = min_dSteerAngle_R;


    end

    % Set the column names
    columnNames = {'lapNumber', 'avgSteerAngle', 'maxSteerAngle_L', 'maxSteerAngle_R', 'minSteerAngle_L', 'minSteerAngle_R', 'avg_dSteerAngle', 'max_dSteerAngle_L', 'max_dSteerAngle_R', 'min_dSteerAngle_L',  'min_dSteerAngle_R'};

    % Save as a table
    lapSummary = table('Size', [size(lapSummaryArray,1), length(columnNames)], ...
        'VariableTypes', {'double', 'double', 'double', 'double', 'double', 'double', 'double'}, ...
        'VariableNames', columnNames);

    lapSummary.lapNumber = lapSummaryArray(:,1);
    lapSummary.avgSteerAngle = lapSummaryArray(:,2);
    lapSummary.maxSteerAngle_L = lapSummaryArray(:,3);
    lapSummary.maxSteerAngle_R = lapSummaryArray(:,4);
    lapSummary.minSteerAngle_L = lapSummaryArray(:,5);
    lapSummary.minSteerAngle_L = lapSummaryArray(:,6);
    lapSummary.avg_dSteerAngle = lapSummaryArray(:,7);
    lapSummary.max_dSteerAngle_L = lapSummaryArray(:,8);
    lapSummary.max_dSteerAngle_R = lapSummaryArray(:,9);
    lapSummary.min_dSteerAngle_L = lapSummaryArray(:,10);
    lapSummary.min_dSteerAngle_R = lapSummaryArray(:,11);




end