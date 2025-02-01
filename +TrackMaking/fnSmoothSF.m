%% Function to smooth the SF straight (avoid discontinuities)
function smoothedSFTrackPoints = fnSmoothSF(trackPoints, nPoints)

    % Set x and y
    x = trackPoints(:,1);
    y = trackPoints(:,2);

    % Get the fwd ref point (origin + nPoints/2)
    xPlus = x(nPoints/2);
    yPlus = y(nPoints/2);

    % Get the bwd ref point (origin - nPoints/2)
    xNeg = x(end - nPoints/2);
    yNeg = y(end - nPoints/2);

    % Set the origin ref count
    t = [1,nPoints]';
    tQ = (1:nPoints)';

    % Interpolate between those points
    xI = interp1(t, [xNeg, xPlus], tQ);
    yI = interp1(t, [yNeg, yPlus], tQ);

    % Add the bottom half to the start of the points
    x(1:nPoints/2) = xI(nPoints/2+1:end);
    y(1:nPoints/2) = yI(nPoints/2+1:end);

    % Add the top half to the end of the points
    x(end - nPoints/2 + 1:end) = xI(1:nPoints/2);
    y(end - nPoints/2 + 1:end) = yI(1:nPoints/2);

    % Set output
    smoothedSFTrackPoints = [x, y];



end