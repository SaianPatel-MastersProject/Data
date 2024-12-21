%% Runs and Laps
runsLaps = {
    '+ProcessedData\2024\FYP12_09\2024_FYP12_09_D4_R02.mat';
};

%% Read in each run data
data = struct('runID', '', 'lapData', table);

for i = 1:size(runsLaps, 1)

    matFilePath = runsLaps{i,1};

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

     % Get the final lap number
     finalLapNumber = runStruct.metadata.laps(size(runStruct.metadata.laps,2)).lapNumber;

     % Only keep flying laps
     runData = runStruct.data(runStruct.data.lapNumber > 0, :);
     runData = runData(runData.lapNumber < 24, :);

     % Check current number of entries in the struct
     nEntries = size(data, 2);

     if isempty(data(1).runID)

         j = 1;

     else

         j = nEntries + 1;

     end

     % Populate the struct
     data(j).runID = runID;
     data(j).runData = runData;


end

%% Join the data as an array
dataArray = [];

for i = 1:size(data, 2)

    data_i = data(i).runData;

    rLookAhead = [];
    nLookAhead = 5;

    for j = 1:size(data_i, 1)

        for k = 1:nLookAhead

            if j + k > size(data_i, 1)
    
                rLookAhead(j,k) = data_i.rCurvature(k);
    
            else

                rLookAhead(j,k) = data_i.rCurvature(j+k);
    
            end
        end

    end
    
    dataArray_i = [data_i.CTE, [0; diff(data_i.CTE)], data_i.rCurvature, rLookAhead, data_i.steerAngle];

    if i == 1

        dataArray = dataArray_i;

    else

        dataArray = [dataArray; dataArray_i];

    end

end
%% Join the data into a single table

columnNames = {
    'CTE';
    'dCTE';
    'rCurvature';
    'r1';
    'r2';
    'r3';
    'r4';
    'r5';
    'steerAngle';
};

trainingData = array2table(dataArray, 'VariableNames',columnNames);

%% Export to CSV

writetable(trainingData, '+NN\+Iteration2\TrainingData_c.csv');