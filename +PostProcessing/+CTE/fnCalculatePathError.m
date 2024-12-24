%% Function to calculate Cross-Track Error (CTE) and Heading Error using Frenet Frames
function [CTE, closestWaypoint, headingError]  = fnCalculatePathError(currentPose, AIW_Data)

    xV = currentPose(1);
    yV = currentPose(2);
    thetaV = currentPose(3);

    % Find nearest AIW waypoint using Euclidean distance
    d = sqrt((AIW_Data(:,1) - xV).^2 + (AIW_Data(:,2) -yV).^2);
    [~, closestWaypointIdx] = min(d);

    closestWaypoint = [AIW_Data(closestWaypointIdx, 1), AIW_Data(closestWaypointIdx, 2)];
    xI = AIW_Data(closestWaypointIdx, 1);
    yI = AIW_Data(closestWaypointIdx, 2);

    if closestWaypointIdx < size(AIW_Data, 1)

        tangentVec = [AIW_Data(closestWaypointIdx + 1, 1) - AIW_Data(closestWaypointIdx, 1), ...
                      AIW_Data(closestWaypointIdx + 1, 2) - AIW_Data(closestWaypointIdx, 2)];

    else

        tangentVec = [AIW_Data(closestWaypointIdx, 1) - AIW_Data(closestWaypointIdx - 1, 1), ...
                      AIW_Data(closestWaypointIdx, 2) - AIW_Data(closestWaypointIdx - 1, 2)];

    end

    % Normalise the tangent vector
    tangentVec = tangentVec / norm(tangentVec);

    % Get the vector perp to the tangent vector
    normalVec = [-tangentVec(2), tangentVec(1)];

    % Get the error vector, the vector between the closest waypoint and the
    % car point
    errorVec = [xV - closestWaypoint(1), yV - closestWaypoint(2)];

    % Calculate the unsigned CTE
    CTE = dot(errorVec, normalVec);

    % Get the heading of the reference
    thetaRef = atan2(tangentVec(2), tangentVec(1));
    headingError = wrapToPi(thetaV - thetaRef);




end