%% Function to create a driving training line export file
function drivingTrainingLine = fnCreateDrivingTrainingLine(matFilePath, lapNumber)

    % Load in the mat
    load(matFilePath);

    % Filter the data to the specified lap
    lapData = runStruct.data(runStruct.data.lapNumber == lapNumber, :);

    % Get x, y, z, throttle and brake
    x = lapData.posX;
    y = lapData.posY;
    z = lapData.posZ;
    rThrottle = lapData.throttle;
    rBrake = lapData.brake;

    % Format for the driving training line
    % [X, Y, Z] to [Y, Z, -X]
    drivingTrainingLine = [y, z, -x, rThrottle, rBrake];

end