%% Create run summary
function [runSummaryTable, lapsTable] = createRunSummary()

    % Select which run to create a summary for
    [runFileName, runFileFolder] = uigetfile('*.mat', 'Select a run .mat file');

    % Check if user selected a file or canceled
    if isequal(runFileName, 0)

        disp('File selection canceled');
        return;

    else
        % Combine path and filename to get the full file path
        runFilePath = fullfile(runFileFolder, runFileName);
        disp(['Selected file: ', runFilePath]);
    end

    % Load in the runStruct
    load(runFilePath);

    % Create a dummy lap struct
    dummyLapStruct = struct();

    for i = 1:size(runStruct.metadata.laps, 2)

        dummyLapStruct(i).Year = string(runStruct.metadata.year); ...
        dummyLapStruct(i).Event = string(runStruct.metadata.event); ...
        dummyLapStruct(i).Day = string(runStruct.metadata.day); ...
        dummyLapStruct(i).Run = string(runStruct.metadata.runNumber); ...
        dummyLapStruct(i).Track = string(runStruct.metadata.track);
        dummyLapStruct(i).Driver = string(runStruct.metadata.driver);
        dummyLapStruct(i).LapNumber = runStruct.metadata.laps(i).lapNumber;
        dummyLapStruct(i).LapTime = runStruct.metadata.laps(i).lapTime;
        dummyLapStruct(i).LapType = runStruct.metadata.laps(i).lapType;
        % dummyLapStruct(i).VehicleModel = runStruct.metadata.vehicleModel;

    end

    % Create a laps table
    lapsTable = struct2table(dummyLapStruct);

    % Create a run summary
    runSummaryCell = {

        'Year', string(runStruct.metadata.year); ...
        'Event', string(runStruct.metadata.event); ...
        'Day', string(runStruct.metadata.day); ...
        'Run', string(runStruct.metadata.runNumber); ...
        'Track', string(runStruct.metadata.track); ...
        'Driver', string(runStruct.metadata.driver); ...
        'Description', string(runStruct.metadata.description); ...
        'Laps', (size(runStruct.metadata.laps, 2)); ...
        'FileName', string(runStruct.metadata.runName); ...
        % 'VehicleModel', string(runStruct.metadata.vehicleModel); ...
    }';

    % Save this as a table
    runSummaryTable = cell2table(runSummaryCell(2,:), "VariableNames", runSummaryCell(1,:));
end