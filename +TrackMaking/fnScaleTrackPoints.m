%% Function to scale track points uniformly
function scaledTrackPoints = fnScaleTrackPoints(trackPoints, s)

    % Set x and y
    x = trackPoints(:,1);
    y = trackPoints(:,2);

    % Set the reference point as the first point
    xRef = x(1);
    yRef = y(1);

    % Apply scaling
    xS = xRef + s * (x - xRef);
    yS = yRef + s * (y - yRef);

    % Set output
    scaledTrackPoints = [xS, yS];



end