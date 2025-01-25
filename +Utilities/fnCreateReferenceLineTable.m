%% Function to create a table for a reference line
function referenceLineTable = fnCreateReferenceLineTable(matFilePath, lapNumber)

    % Load in the mat
    load(matFilePath);

    % Filter the data to the specified lap
    lapData = runStruct.data(runStruct.data.lapNumber == lapNumber, :);

    % Get x, y, z, throttle and brake
    x = lapData.posX;
    y = lapData.posY;
    z = lapData.posZ;

    referenceLineTable = [x, y, z];
    columnNames = {'x', 'y', 'z'};
    referenceLineTable = array2table(referenceLineTable, 'VariableNames', columnNames);

end