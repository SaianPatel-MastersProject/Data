function [CTE, closestWaypoint]  = calculateCTE(currentPosition, AIW_Data)

    xV = currentPosition(1);
    yV = currentPosition(2);

    % Find nearest AIW waypoint using Euclidean distance
    d = sqrt((AIW_Data(:,1) - xV).^2 + (AIW_Data(:,2) -yV).^2);
    [minDist, closestWaypointIdx] = min(d);

    closestWaypoint = [AIW_Data(closestWaypointIdx, 1), AIW_Data(closestWaypointIdx, 2)];
    xI = AIW_Data(closestWaypointIdx, 1);
    yI = AIW_Data(closestWaypointIdx, 2);

    if closestWaypointIdx ~= size(AIW_Data, 1)
        xI_1 = AIW_Data(closestWaypointIdx+1, 1);
        yI_1 = AIW_Data(closestWaypointIdx+1, 2);
    else
        xI_1 = AIW_Data(1, 1);
        yI_1 = AIW_Data(1, 2);
    end

    % Segment between path points
    p = [xI_1 - xI; yI_1 - yI];

    % Vector from path to vehicle
    v = [xV - xI; yV - yI];

    % Projection of v onto p
    dotP = dot(p, v);
    pMagSquared = dot(p, p);
    proj_v_on_p = (dotP / pMagSquared) * p;

    % Calc residual vect
    residual = v - proj_v_on_p;

    % CTE
    CTE = norm(residual);

    % Get the sign of CTE
    crossProd = p(1) * v(2) - p(2) * v(1);
    if crossProd > 0

        CTE = CTE; % Left of path

    else

        CTE = -CTE; % Right of path

    end


end