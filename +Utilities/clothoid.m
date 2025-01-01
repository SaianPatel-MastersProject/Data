%%
% Coordinates of points
x1 = -149.624; y1 = 55.177; % Current point
x2 = -147.6571; y2 = 54.6840; % Target point
x3 = -147.3103; y3 = 54.5926; % Next reference point

% Initialize ClothoidList object
C = ClothoidList();

% First clothoid: from (x1, y1) to (x2, y2)
C.build_G1(x1, y1, atan2(y2-y1, x2-x1), x2, y2, atan2(y3-y2, x3-x2));
clothoid1 = C.getClothoid(1); % First segment

% Extract properties
k1_start = clothoid1.kappaStart();
k1_end = clothoid1.kappaEnd();
k1_prime = (k1_end - k1_start) / clothoid1.length();
L1 = clothoid1.length();

% Second clothoid: from (x2, y2) to (x3, y3)
C.build_G1(x2, y2, atan2(y3-y2, x3-x2), x3, y3, atan2(y3-y2, x3-x2));
clothoid2 = C.getClothoid(2); % Second segment

% Extract properties
k2_start = clothoid2.kappaStart();
k2_end = clothoid2.kappaEnd();
k2_prime = (k2_end - k2_start) / clothoid2.length();
L2 = clothoid2.length();

% Display results
fprintf('Clothoid 1: Start Curvature = %.4f, End Curvature = %.4f, Curvature Derivative = %.4f, Length = %.4f\n', ...
        k1_start, k1_end, k1_prime, L1);
fprintf('Clothoid 2: Start Curvature = %.4f, End Curvature = %.4f, Curvature Derivative = %.4f, Length = %.4f\n', ...
        k2_start, k2_end, k2_prime, L2);
