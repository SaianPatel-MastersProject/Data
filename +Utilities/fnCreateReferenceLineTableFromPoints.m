%% Function to create a table for a reference line
function referenceLineTable = fnCreateReferenceLineTableFromPoints(trackPoints, z)

    % Get x and y
    x = trackPoints(:,1);
    y = trackPoints(:,2);
    dx = [0.1; diff(x)];
    dy = [0.1; diff(y)];

    % Check for repeats
    dBetweenPoints = (sqrt(dx.^2 + dy.^2));
    nRepeats = numel(dBetweenPoints(dBetweenPoints == 0)) - 1;

    % If there are repeats, remove them
    if nRepeats > 0

        x = x(dBetweenPoints ~=0);
        y = y(dBetweenPoints ~=0);

    end

    % Set z
    z = ones([numel(x), 1]) * z;

    % Interpolate
    dBetweenPoints(1) = 1e-6;
    dRolling = cumsum(dBetweenPoints(dBetweenPoints ~= 0));
    dNew = (0:1:dRolling(end))'; % Sampling every 1m
    xI = interp1(dRolling, x, dNew, 'spline');
    yI = interp1(dRolling, y, dNew, 'spline');
    zI = interp1(dRolling, z, dNew, 'spline');



    referenceLineTable = [xI, yI, zI];
    columnNames = {'x', 'y', 'z'};
    referenceLineTable = array2table(referenceLineTable, 'VariableNames', columnNames);

end