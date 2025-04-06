function postProcessAvgLap(matFilePath, lapsFilter)

    % Read in a run .mat file
    load(matFilePath);

    % Load Associated Layers
    runStruct = Utilities.fnLoadLayer(runStruct, 'PE');
    runStruct = Utilities.fnLoadLayer(runStruct, 'KAP');
    runStruct = Utilities.fnLoadLayer(runStruct, 'ProMoD');

    % Check how many laps are in the run
    lapsInRun = unique(runStruct.data.lapNumber);
    nLaps = length(lapsInRun);

    % Apply the laps filter
    if ~isempty(lapsFilter)

        for i = 1:numel(lapsFilter)

            runData_i = runStruct.data(runStruct.data.lapNumber == lapsFilter(i), :);

            if i == 1

                runData = runData_i;

            else

                runData = [runData; runData_i];

            end

        end

    % Get the laps in the run
    lapsInRun = unique(runData.lapNumber);

    % If there are more than 2 laps (i.e. at least one flying lap
    % with an out and in lap) then only keep the flying laps
    elseif nLaps > 2

        runData = runStruct.data(runStruct.data.lapNumber < lapsInRun(end), :);
        runData = runData(runData.lapNumber > 0, :);
        lapsInRun = lapsInRun(2:end-1);

    else

        runData = runStruct.data;
        warning('Using all laps in the run.')

    end

    %% Re-interpolate each lap to a common sLap vector
    nLaps = size(lapsInRun,1);

    % Get the largest start distance and smallest end distance for the set of laps
    lapStart = -1;
    lapEnd = 1e6;

    for i = 1:nLaps

        lap_i = lapsInRun(i);

        lapData = runData(runData.lapNumber == lap_i, :);

        lapStart_i = min(lapData.lapDist);

        lapEnd_i = max(lapData.lapDist);

        % Update as necessary
        if lapStart_i > lapStart

            lapStart = lapStart_i;

        end

        if lapEnd_i < lapEnd

            lapEnd = lapEnd_i;

        end

    end

    % Re-interpolate to a common sLap vector
    pointsSpacing = 0.4;
    sLap = (lapStart:pointsSpacing:lapEnd)';

    % Create a dummy time vector
    dt = 0.01;
    tLap = (0:dt:(numel(sLap)-1)*dt)';

    % Create an empty table which matches the columns of the reference run
    nCols = size(runData, 2);
    nRows = size(sLap, 1);
    avgLapData = zeros([nRows, nCols]);

    avgLapData = array2table(avgLapData, 'VariableNames', runData.Properties.VariableNames);

    % Pre-assign the relevant cols
    avgLapData.time = tLap;
    avgLapData.lapDist = sLap;
    avgLapData.sLapRef = sLap;
    avgLapData.lapNumber(:) = 99;

    % Set the columns to iterate over
    columnNames = runData.Properties.VariableNames;
    columnNames{strcmp(columnNames, 'time')} = {};
    columnNames{strcmp(columnNames, 'lapDist')} = {};
    columnNames{strcmp(columnNames, 'sLapRef')} = {};
    columnNames{strcmp(columnNames, 'lapNumber')} = {};

    % Remove empties
    columnNames = columnNames(~cellfun('isempty', columnNames));

    % Create a struct array with the column name and interpolated data
    dataInterp = struct('channel', '', 'channelDataInterp', []);

    % For each lap, re-interpolate using sLap, then average
    for i = 1:nLaps

        % Get the data for this lap
        lapData = runData(runData.lapNumber == lapsInRun(i), :);

        % Find where lapDist stutters
        dLapDist = [1; diff(lapData.lapDist)];
        stutterIdx = dLapDist ~= 0;
        lapData = lapData(stutterIdx, :);

        % Iterate over the channels
        for j = 1:length(columnNames)

            % Set the channel
            channel_j = columnNames{j};
            dataInterp(j).channel = channel_j;

            if i == 1

                dataInterp(j).channelDataInterp = interp1(lapData.lapDist, lapData.(channel_j), sLap);

            else

                dataInterp(j).channelDataInterp = [dataInterp(j).channelDataInterp, interp1(lapData.lapDist, lapData.(channel_j), sLap)];


            end


        end


    end

    %% Average the data

    % For each channel, index the struct array, average the data and store
    % it in the avgLapData table
    for i = 1:length(columnNames)

        avgLapData.(dataInterp(i).channel) = mean(dataInterp(i).channelDataInterp, 2);

    end



    %% Compile the layer (like a runStruct)
    
    % Copy the metadata
    avgLapMetadata = runStruct.metadata;

    % Update the relevant fields
    avgLapMetadata.laps = struct('lapNumber', 99, 'lapTime', avgLapData.time(end), 'lapType', 1);
    avgLapMetadata.fastestLap = avgLapMetadata.laps;
    avgLapMetadata.description = sprintf('%s - Average Lap', avgLapMetadata.runID);

    % Format the runStruct
    runStruct.data = avgLapData;
    runStruct.metadata = avgLapMetadata;

    % Set the .mat filename
    avgLapFilePath = strrep(avgLapMetadata.matFilePath, '.mat', '_AvgLap.mat');

    % Save the .mat
    save(avgLapFilePath, 'runStruct');




end