%% Function to create a new AIW csv
function fnCreateAIWCSV(matFilePath, lapNumber)

    % Read in the run
    load(matFilePath)

    % Fetch the data for the selected lap
    lapData = runStruct.data(runStruct.data.lapNumber == lapNumber, :);

    % Fetch the track name
    trackName = runStruct.metadata.track;

    % Get the number of rows
    nRows = size(lapData, 1);

    % Specify Column Names
    columnNames = {'x', 'y', 'z'};

    AIW_Table = table('Size', [nRows, 3], ...
        'VariableTypes', {'double', 'double', 'double'}, ...
        'VariableNames', columnNames);

    AIW_Table.x = lapData.posX;
    AIW_Table.y = lapData.posY;
    AIW_Table.z = lapData.posZ;

    switch trackName

        case "Arrow Speedway"

            csvFileName = "Arrow.csv";

    end

    csvFilePath = fullfile("+PostProcessing\+AIW", csvFileName);

    % Write to a CSV
    writetable(AIW_Table, csvFilePath);

end