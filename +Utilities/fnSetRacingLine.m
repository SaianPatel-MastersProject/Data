%% Function to set rFpro Racing Line
function fnSetRacingLine(track)

    % Read the look-up table
    AIW_LookUp = readtable("D:\Users\Saian\Workspace\Tracks\TrackDB\AIW_LookUp.xlsx", 'VariableNamingRule','preserve');

    % Get the AIW filepath for the track of interest
    AIW_FilePath = AIW_LookUp.AIW_FilePath(strcmp(AIW_LookUp.Track, track));

    % Get the DrivingLineExport csv
    RL_FilePath = strrep(AIW_FilePath, 'AIW_Table.csv', 'DrivingLineExport.csv');
    RL_FilePath = RL_FilePath{1};

    % Check if this csv exists
    if ~isfile(RL_FilePath)

        % Return if the csv doesn't exist
        return;

    end

    % Move the RL csv into the rFpro Folder
    rFpro_Folder = 'D:\rFpro_2024a\rFpro';
    rFpro_FilePath = fullfile(rFpro_Folder, 'DrivingLineExport.csv');
    copyfile(RL_FilePath, rFpro_FilePath);

end