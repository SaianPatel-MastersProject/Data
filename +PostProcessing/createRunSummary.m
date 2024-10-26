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

    % Create a laps table
    lapsTable = struct2table(runStruct.metadata.laps);

    % Create a run summary
    runSummaryCell = {

        'Year', runStruct.metadata.year; ...
        'Event', runStruct.metadata.event; ...
        'Day', runStruct.metadata.day; ...
        'Run', runStruct.metadata.runNumber; ...
        'Driver', runStruct.metadata.driver; ...
        'Description', runStruct.metadata.description; ...
        'Laps', (size(runStruct.metadata.laps, 2)); ...
        % 'VehicleModel', runStruct.metadata.vehicleModel; ...
        'FileName', runStruct.metadata.runName; ...
    }';

    % Save this as a table
    runSummaryTable = cell2table(runSummaryCell(2,:), "VariableNames", runSummaryCell(1,:));
end