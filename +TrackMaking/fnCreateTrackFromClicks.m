function trackPoints = fnCreateTrackFromClicks(image_path, x0, y0, x1, y1)
    % Function to extract trajectory from an image, smooth it, translate, and rotate
    
    % Load and display image
    img = imread(image_path);
    figure;
    imshow(img);
    hold on;
    title('Click to define trajectory points. Press Enter when done.');

    % Get user-selected points
    [x, y] = ginput;

    y = -y;
    
    % Close figure after selection
    close;
    
    % Ensure sufficient points
    if length(x) < 2
        error('At least two points are required.');
    end
    
    % Get the distance between the points
    dx = [0; diff(x)];
    dy = [0; diff(y)];
    dRolling = sqrt(dx.^2+dy.^2);
    d = cumsum(dRolling);
    dInterval = [d(1), d(end)];

    % Interpolate by sampling every 1 unit length
    dNew = (0:1:d(end));
    
    % Use B-Splines (Robotics System Toolbox)
    [q, ~, ~] = bsplinepolytraj([x, y]', dInterval, dNew);

    % Get interpolate x and y
    xI = q(1,:)';
    yI = q(2,:)';

    % Store as trackPoints
    trackPoints = [xI, yI];


end
