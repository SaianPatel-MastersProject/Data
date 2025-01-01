%% Find the closest 

xV = -149.624;
yV = 55.177;

% dist
distAlongWaypoints = [0; cumsum(sqrt((diff(waypoints(:,1))).^2 + (diff(waypoints(:,2))).^2))];

% Find nearest AIW waypoint using Euclidean distance
d = sqrt((waypoints(:,1) - xV).^2 + (waypoints(:,2) -yV).^2);
[minDist, closestWaypointIdx] = min(d);

closestWaypoint = [waypoints(closestWaypointIdx, 1), waypoints(closestWaypointIdx, 2)];
xI = waypoints(closestWaypointIdx, 1);
yI = waypoints(closestWaypointIdx, 2);

L_d = 3;

% Find the look-ahead point by spline interpolation
xInterp = interp1(distAlongWaypoints, waypoints(:,1), distAlongWaypoints(closestWaypointIdx) + L_d, 'spline' );
yInterp = interp1(distAlongWaypoints, waypoints(:,2), distAlongWaypoints(closestWaypointIdx) + L_d, 'spline' );