%% Function to translate track points to start on the origin
function translatedTrackPoints = fnTranslateTrackPoints(trackPoints, x0, y0)

    % Set x and y
    x = trackPoints(:,1);
    y = trackPoints(:,2);

    % Difference between first point and origin
    dx = x(1) - x0;
    dy = y(1) - y0;

    % Apply translation to all points
    xT = x - dx;
    yT = y - dy;

    % Set output
    translatedTrackPoints = [xT, yT];



end