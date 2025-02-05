%% Function to load a AIW csv for a specified track
function AIW_Table = fnLoadAIW(track)

    % Read the look-up table
    AIW_LookUp = readtable("D:\Users\Saian\Workspace\Tracks\TrackDB\AIW_LookUp.xlsx", 'VariableNamingRule','preserve');

    % Get the AIW filepath for the track of interest
    AIW_FilePath = AIW_LookUp.AIW_FilePath(strcmp(AIW_LookUp.Track, track));

    % Read that AIW table
    AIW_Table = readtable(AIW_FilePath{1});

end