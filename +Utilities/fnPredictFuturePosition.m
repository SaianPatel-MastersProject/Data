%% Function to calculate future position (steering based)
function [xF, yF, psiF] = fnPredictFuturePosition(xV, yV, steerAngle, dSteerAngle, yawAngle, previewTime, v)


    % Get the number of indices for the preview window
    n = previewTime / 0.01;

    % Integrate dSteer to get a steering profile over the preview period
    dSteerWindow = zeros([n,1]);

    % Assume constant steering velocity in the preview window
    dSteerWindow(:,1) = dSteerAngle;

    % Calculate the steering profile in the preview window by integrating
    steerWindow = steerAngle + cumsum(dSteerWindow) .* 0.01;

    % Produce a window of yaw angles
    yawAngleWindow = zeros([n,1]);
    yawAngleWindow(1,1) = yawAngle;

    % Loop through the preview window
    for j = 2:n
        
        % Calculate future yawAngle using Euler Forward Integration
        yawAngleWindow(j,1) = yawAngleWindow(j-1) + steerWindow(j-1)* -1.5 * 0.01;

    end

    % Use the final yaw angle in the preview window for position prediction
    yawAngleF = yawAngleWindow(end);
    psiF = yawAngleF;

    % Predict the change in position
    dXF = v * cos(yawAngleF) * previewTime;
    dYF = v * sin(yawAngleF) * previewTime;

    % Predict future position
    xF = xV + dXF;
    yF = yV + dYF;





end