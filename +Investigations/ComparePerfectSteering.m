%% Load Human and FFFN data
obj = Plotting.multiPlotter();

obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', 31); % Human
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_10\2025_FYP02_10_D1_R02.mat', 4); % FFNN 48
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_17\2025_FYP02_17_D1_R04.mat', 4); % FFNN 58
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP03_17\2025_FYP03_17_D2_R01.mat', 4); % FFNN 68

%% Read in reference data for each variant of SUZ
tracks = {'SUZ'};
nTracks = length(tracks);
masterKappa = [];

for i = 1:nTracks

    AIW_Table = Utilities.fnLoadAIW(tracks{i});
    AIW_Data = [AIW_Table.x, AIW_Table.y];

    % Get the curvature, kappa
    [kappa, ~] = PostProcessing.PE.fnCalculateCurvature([AIW_Table.x, AIW_Table.y]);


    spacing = 0.1;
    method = 'spline';

    xInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.x, spacing, method);
    yInterp = Utilities.fnInterpolateByDist(AIW_Data, AIW_Table.y, spacing, method);
    kappaInterp_i = Utilities.fnInterpolateByDist(AIW_Data, kappa, spacing, method);

    if i == 1

        masterKappa = kappaInterp_i;

    else

        masterKappa = [masterKappa; kappaInterp_i];

    end

end

%% For each kappa, calculate steering angle if following the racing line perfectly
v = 40;
k = -1.5;

nPoints = size(masterKappa, 1);

perfectSteering = (masterKappa .* v) ./ k;

%% Overlay perfect steering with human and FFNN
figure;
hold on
grid on;
grid minor;
% Perfect
plot(obj.data(1).lapData.lapDist, ((obj.data(1).lapData.kappa .* v) ./ k))

% Human
plot(obj.data(1).lapData.lapDist, obj.data(1).lapData.steerAngle)

% FFNN
plot(obj.data(2).lapData.lapDist, obj.data(2).lapData.steerAngle)

legend({'Perfect', 'Human', 'FFNN'})

%% Plot delta to perfect steering

figure;
hold on
grid on;
grid minor;

% Human
hDelta = obj.data(1).lapData.steerAngle - ((obj.data(1).lapData.kappa .* v) ./ k);
plot(obj.data(1).lapData.lapDist, hDelta)

% FFNN - SM48
fDelta = obj.data(2).lapData.steerAngle - ((obj.data(2).lapData.kappa .* v) ./ k);
plot(obj.data(2).lapData.lapDist, fDelta)

% FFNN - SM58
fDelta2 = obj.data(3).lapData.steerAngle - ((obj.data(3).lapData.kappa .* v) ./ k);
plot(obj.data(3).lapData.lapDist, fDelta2)

% FFNN - SM68
fDelta3 = obj.data(4).lapData.steerAngle - ((obj.data(4).lapData.kappa .* v) ./ k);
plot(obj.data(4).lapData.lapDist, fDelta3)

legend({'Human', 'SM48', 'SM58', 'SM68'})

%% Plot deltas as a function of CTE and HE
figure;
hold on
grid on;
grid minor;
scatter3(obj.data(1).lapData.CTE, obj.data(1).lapData.HeadingError, hDelta)
scatter3(obj.data(2).lapData.CTE, obj.data(2).lapData.HeadingError, fDelta)
scatter3(obj.data(3).lapData.CTE, obj.data(3).lapData.HeadingError, fDelta2)
scatter3(obj.data(4).lapData.CTE, obj.data(4).lapData.HeadingError, fDelta3)
xlabel('CTE')
ylabel('HE')
zlabel('Delta to Perfect Steering')
legend({'Human', 'SM48', 'SM58', 'SM68'})


