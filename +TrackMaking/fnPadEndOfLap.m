%% Function to pad the end of the lap
function trackPointsPadded = fnPadEndOfLap(trackPoints, threshold)

    % Set x and y
    x = trackPoints(:,1);
    y = trackPoints(:,2);

    % Check the distance between the last and first point
    dEnd = sqrt((x(1) - x(end))^2 + (y(1) - y(end))^2);

    % Only pad if the gap is bigger than 1m
    if dEnd > threshold

        d = [0; dEnd];
        dQ = (0 : 1 : dEnd - threshold)';
        xI = interp1(d, [x(end); x(1)], dQ);
        yI = interp1(d, [y(end); y(1)], dQ);

        % Pad
        x = [x; xI; x(1)];
        y = [y; yI; y(1)];

    end

    trackPointsPadded = [x, y];




end