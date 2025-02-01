%% Function to create a driving training line export file
function drivingTrainingLine = fnCreateDrivingTrainingLinePoints(trackPoints)

    % Get x, y, z, throttle and brake
    x = trackPoints(:,1);
    y = trackPoints(:,2);
    z = ones([numel(x),1]) * 0.249;
    rThrottle = ones([numel(x),1]);
    rBrake = zeros([numel(x),1]);

    % Format for the driving training line
    % [X, Y, Z] to [Y, Z, -X]
    drivingTrainingLine = [y, z, -x, rThrottle, rBrake];

end