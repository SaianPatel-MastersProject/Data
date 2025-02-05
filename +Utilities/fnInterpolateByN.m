%% Function to interpolate by nPoints
function interpolatedData = fnInterpolateByN(posData, data, nPoints, method)

    % Get x and y
    x = posData(:,1);
    y = posData(:,2);

    % Get changes in x and y
    dx = [0; diff(x)];
    dy = [0; diff(y)];

    % Get distances
    dBetweenPoints = sqrt((dx).^2 + (dy).^2);
    dRolling = cumsum(dBetweenPoints);
    dNew = (linspace(0, dRolling(end), nPoints))';

    % Interpolate data
    interpolatedData = interp1(dRolling, data, dNew, method);

end