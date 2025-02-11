%% Function to get the loop distance for a lap
function AIW_lapDist = fnLapDistAIW(track)

    % Load AIW Data
    AIW_Table = Utilities.fnLoadAIW(track);
    xRefOriginal = [AIW_Table.x];
    yRefOriginal = [AIW_Table.y];

    % Loop the coordinates
    xRefOriginal = [xRefOriginal; xRefOriginal(1)];
    yRefOriginal = [yRefOriginal; yRefOriginal(1)];

    % Interpolate
    xRef = Utilities.fnInterpolateByDist([xRefOriginal, yRefOriginal], xRefOriginal, 0.1, 'spline');
    yRef = Utilities.fnInterpolateByDist([xRefOriginal, yRefOriginal], yRefOriginal, 0.1, 'spline');

    % Get the total lap distance
    dBetweenPoints = (sqrt(diff(xRef).^2 + diff(yRef).^2));
    rollingDistance = [0; cumsum(dBetweenPoints)];

    AIW_lapDist = rollingDistance(end);

end