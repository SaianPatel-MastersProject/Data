%% Read in training data
trainingData = readtable("D:\Users\Saian\Workspace\NeuralNetworks\FFNN\Iteration66\TrainingData.csv", 'VariableNamingRule', 'preserve');

%% Read in reference data for each variant of SUZ
tracks = {'SUZ', 'SUZ_R', 'SUZ_M', 'SUZ_MR'};
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

%% Plot results
figure;
scatter( trainingData.curvature, trainingData.steerAngle, '.', 'SizeData', 4, 'MarkerEdgeColor', 'b')
hold on
scatter(masterKappa, perfectSteering, '.', 'SizeData', 32, 'MarkerEdgeColor', 'r')
grid on
grid minor

xlabel('Curvature (\kappa)')
ylabel('Steering Angle')
legend({'Human Training Data', 'Perfect Steering'})

%% Plot results - colourmap for CTE
figure;
p1 = scatter( trainingData.curvature, trainingData.steerAngle, 4, (trainingData.CTE), 'filled');
hold on
% p2 = scatter(masterKappa, perfectSteering, '.', 'SizeData', 32, 'MarkerEdgeColor', 'r');
p2 = scatter(masterKappa, perfectSteering, 4, 'MarkerEdgeColor', 'r', 'MarkerFaceColor','r');
grid on
grid minor
c = colorbar;
c.Label.String = 'CTE $C$ [m]';
c.Label.Interpreter = 'latex';
% title('Curvature vs Steering Angle with CTE')
xlabel('Curvature $\kappa$ [1/m])', 'Interpreter','latex')
ylabel('Steering Angle $\delta$ [deg]', 'Interpreter','latex')
legend({'Human Demonstration Data', 'Ideal Steering'}, 'Interpreter','latex')
set(gca,"TickLabelInterpreter",'latex')
fontsize(24, "points");

%% Plot results - colourmap for HE
figure;
scatter( trainingData.curvature, trainingData.steerAngle, 4, trainingData.HeadingError, 'filled')
hold on
scatter(masterKappa, perfectSteering, '.', 'SizeData', 32, 'MarkerEdgeColor', 'r')
grid on
grid minor
c = colorbar;
c.Label.String = 'HE';
title('Curvature vs Steering Angle with HE')
xlabel('Curvature (\kappa)', 'FontWeight','bold')
ylabel('Steering Angle (\delta)', 'FontWeight','bold')
legend({'Human Training Data', 'Perfect Steering'}, 'FontSize', 14)

%% Plot results - colourmap for LA
figure;
scatter( trainingData.curvature, trainingData.steerAngle, 4, trainingData.lookAhead1, 'filled')
hold on
scatter(masterKappa, perfectSteering, '.', 'SizeData', 32, 'MarkerEdgeColor', 'r')
grid on
grid minor
c = colorbar;
c.Label.String = 'LA Curvature';
title('Curvature vs Steering Angle with LA Curvature')
xlabel('Curvature (\kappa)', 'FontWeight','bold')
ylabel('Steering Angle (\delta)', 'FontWeight','bold')
legend({'Human Training Data', 'Perfect Steering'}, 'FontSize', 14)

%% Plot 3D Scatter with derivative of absolute curvature
absKappa = abs(trainingData.curvature);
dKappa = [0; diff(absKappa)] ./ 0.4;
dMasterKappa = [0; diff(abs(masterKappa))] ./ 0.1;

figure;
grid on
grid minor
ylabel('Steering Angle')
xlabel('Curvature (\kappa)')
zlabel('Derivative of Abs Curvature')
hold on
scatter3(trainingData.steerAngle, trainingData.curvature, dKappa, '.', 'SizeData', 4)
scatter3(perfectSteering, masterKappa, dMasterKappa, '.', 'SizeData', 32, 'MarkerEdgeColor', 'r')
legend({'Human Training Data', 'Perfect Steering'})

