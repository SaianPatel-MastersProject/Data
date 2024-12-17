%% Import Neural Network
net = importNetworkFromONNX("D:\Users\Saian\Workspace\NeuralNetworks\FFNN\Iteration0\steering_model.onnx", "InputDataFormats", "BC");

%% Import Reference Run

matFilePath = '+ProcessedData\2024\FYP12_09\2024_FYP12_09_D4_R02.mat';
lap = 12;

% Read in a run .mat file
load(matFilePath);

% Get the runID
runID = runStruct.metadata.runID;

% Read in CTE layers if they exist
CTEmatFilePath = strrep(matFilePath, '.mat', '_CTE.mat');

if isfile(CTEmatFilePath)

    % Load the CTE layer
    load(CTEmatFilePath)

    % Join CTE layer to the data for the run
    runStruct.data = addvars(runStruct.data, dataCTE.CTE, 'NewVariableNames', 'CTE');
    runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointX, 'NewVariableNames', 'closestWaypointX');
    runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointY, 'NewVariableNames', 'closestWaypointY');


end

% Read in VE layers if they exist
VEmatFilePath = strrep(matFilePath, '.mat', '_VE.mat');

if isfile(VEmatFilePath)

    % Load the CTE layer
    load(VEmatFilePath)

    % Join CTE layer to the data for the run
    runStruct.data = addvars(runStruct.data, dataVE.vError, 'NewVariableNames', 'vError');
    runStruct.data = addvars(runStruct.data, dataVE.refVel, 'NewVariableNames', 'refVel');
    runStruct.data = addvars(runStruct.data, dataVE.rCurvature, 'NewVariableNames', 'rCurvature');


end

% Read in ProMoD layers if they exist
ProMoDmatFilePath = strrep(matFilePath, '.mat', '_ProMoD.mat');

if isfile(ProMoDmatFilePath)

    % Load the CTE layer
    load(ProMoDmatFilePath)

    % Join CTE layer to the data for the run
    runStruct.data = addvars(runStruct.data, dataProMoD.MSteer, 'NewVariableNames', 'MSteer');

end

% filter by lap
runStruct.data = runStruct.data(runStruct.data.lapNumber == lap, :);

%% Run the sim
NN_Sim_Data = [runStruct.data.time - runStruct.data.time(1)];

for i = 1:size(runStruct.data, 1)

    CTE = runStruct.data.CTE(i);
    dCTEcol = [0; diff(runStruct.data.CTE)];
    dCTE = dCTEcol(i);
    rCurvature = runStruct.data.rCurvature(i);
    d_rCuravtureCol = [0; diff(runStruct.data.rCurvature)];
    d_rCurvature = d_rCuravtureCol(i);

    input_i = [CTE, dCTE, rCurvature, d_rCurvature];

    steeringOutput_i = predict(net, input_i);

    % Populate the array
    NN_Sim_Data(i,2:5) = input_i;
    NN_Sim_Data(i,6) = steeringOutput_i;

end

%% Plotting results
figure;
% subplot(5,1,1)
plot(NN_Sim_Data(:,1), runStruct.data.steerAngle)
hold on
plot(NN_Sim_Data(:,1), NN_Sim_Data(:,6))
xlabel('Time (s)')
ylabel('steerAngle')

% subplot(5,1,2)
% plot(NN_Sim_Data(:,1), runStruct.data.CTE)
% hold on
% plot(NN_Sim_Data(:,1), NN_Sim_Data(:,2))
% xlabel('Time (s)')
% ylabel('CTE')
% 
% subplot(5,1,3)
% plot(NN_Sim_Data(:,1), [0; diff(runStruct.data.CTE)])
% hold on
% plot(NN_Sim_Data(:,1), NN_Sim_Data(:,3))
% xlabel('Time (s)')
% ylabel('dCTE')
% 
% subplot(5,1,4)
% plot(NN_Sim_Data(:,1), runStruct.data.rCurvature)
% hold on
% plot(NN_Sim_Data(:,1), NN_Sim_Data(:,4))
% xlabel('Time (s)')
% ylabel('rCurvature')
% 
% subplot(5,1,5)
% plot(NN_Sim_Data(:,1), [0; diff(runStruct.data.rCurvature)])
% hold on
% plot(NN_Sim_Data(:,1), NN_Sim_Data(:,5))
% xlabel('Time (s)')
% ylabel('d_rCurvature')