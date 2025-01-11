%% Function for detecting stutters
function [nStutter, stutterIdx] = fnDetectStutters(data)

    % Get the car positions
    x = data.posX;
    y = data.posY;
    z = data.posZ;

    % Get the car speed
    vCar = data.speed;

    % Check whether the car is moving
    bMoving = vCar > 0.1;

    % Get the diff of each
    dX = diff(x);
    dY = diff(y);
    dZ = diff(z);

    % If there is a stutter, the position is held
    dX_0 = dX == 0;
    dY_0 = dY == 0;
    dZ_0 = dZ == 0;

    % Find when there is a stutter (when all diff are 0, when the car is moving)
    stutterIdx = [0; dX_0 .* dY_0 .* dZ_0];
    stutterIdx = stutterIdx .* bMoving;

    % Count how many stutters there are
    nStutter = sum(stutterIdx); 

    if nStutter == 0

        fprintf('There are no stutters in the data.');

    else

        fprintf('There are %i stutter(s) in the data.', nStutter);

    end


end