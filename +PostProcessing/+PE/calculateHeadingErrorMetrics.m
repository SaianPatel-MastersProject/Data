function summary = calculateHeadingErrorMetrics(runStruct, lapNumber)

    % Check nargin - <2 means lapNumber not given
    if nargin < 2

        % Create a boolean for all laps or single lap calc
        allLaps = true;

    else

        % If a lap is provided then set allLaps as false
        allLaps = false;

    end

    
    % Get the table column names
    tableColumns = runStruct.data.Properties.VariableNames;

    % Check if CTE exists, if it doesn't, try to reload layers
    if ~ismember(tableColumns, 'HeadingError')

        % Get the matfilepath
        matFilePath = runStruct.metadata.matFilePath;

        % Read in PE/CTE layers if they exist
        PEmatFilePath = strrep(matFilePath, '.mat', '_PE.mat');

        if isfile(PEmatFilePath)

            % Load the CTE layer
            load(PEmatFilePath)

            % Join CTE layer to the data for the run
            runStruct.data = addvars(runStruct.data, dataPE.CTE, 'NewVariableNames', 'CTE');
            runStruct.data = addvars(runStruct.data, dataPE.closestWaypointX, 'NewVariableNames', 'closestWaypointX');
            runStruct.data = addvars(runStruct.data, dataPE.closestWaypointY, 'NewVariableNames', 'closestWaypointY');
            runStruct.data = addvars(runStruct.data, dataPE.HeadingError, 'NewVariableNames', 'HeadingError');

        end
    
        
    end

    % Check again if CTE exists
    tableColumns = runStruct.data.Properties.VariableNames;

    if ~ismember(tableColumns, 'HeadingError')

        sprintf('No HeadingError data found for: %s. \n', runStruct.metadata.runID);

    end

    % Get the number of laps
    nLaps = size(runStruct.metadata.laps, 2);


    % Create a summary array
    summary =zeros([nLaps, 6]);

    % Loop through each lap
    for i = 1:nLaps

        % Get the data for the lap
        lapData = runStruct.data(runStruct.data.lapNumber == i - 1, :);

        % Create a lap time channel
        lapData.tLap = lapData.time - lapData.time(1);

        % Get dt
        dt = lapData.tLap(2) - lapData.tLap(1);

        % Get the derivative of HE
        dHE = [0; diff(lapData.HeadingError) ./ dt];

        % Get the derivative of abs HE
        dAHE = [0; diff(abs(lapData.HeadingError)) ./ dt];

        % Get the overall integral of HE
        THE = trapz(lapData.tLap, lapData.HeadingError);

        % Get the integral of absolute HE
        TAHE = trapz(lapData.tLap, abs(lapData.HeadingError));

        % Find where absolute HE is improving (dHE < 0)
        rIdx = (dAHE) < 0;

        % Find where absolute HE is worsening (dHE > 0)
        wIdx = (dAHE) > 0;

        % Get the improvement intergal (signed and unsigned)
        rRegions = Utilities.fnFindContinuousRegions(rIdx);
        rHE_bias = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, lapData.HeadingError, rRegions);
        rHE = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, abs(lapData.HeadingError), rRegions);

        % Get the worsening intergal (signed and unsigned)
        wRegions = Utilities.fnFindContinuousRegions(wIdx);
        wHE_bias = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, lapData.HeadingError, wRegions);
        wHE = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, abs(lapData.HeadingError), wRegions);

        % Calculate r_r,w
        rRW = rHE / (rHE + wHE);

        % Get the number of HE corrections
        nCorrectionsHE = Utilities.fnFindCorrections(lapData.HeadingError);

        % Get the number of HE=0 crosses
        nCrossesHE = Utilities.fnFindXCrosses(lapData.HeadingError);

        % Get the number of steering corrections
        nCorrectionsSteering = Utilities.fnFindCorrections(lapData.steerAngle);

        % Populate the array
        summary(i,1) = THE;
        summary(i,2) = TAHE;
        summary(i,3) = rHE;
        summary(i,4) = rHE_bias;
        summary(i,5) = wHE;
        summary(i,6) = wHE_bias;
        summary(i,7) = rRW;
        summary(i,8) = nCorrectionsHE;
        summary(i,9) = nCrossesHE;
        summary(i,10) = nCorrectionsSteering;

    end
        

    % Convert array to table
    columnNames = {'THE'; 'TAHE'; 'rHE'; 'rHE_bias'; 'wHE'; 'wHE_bias'; 'rRW'; 'nCorrcectionsHE'; 'nCrossesHE'; 'nCorrectionsSteering'};
    summary = array2table(summary, 'VariableNames', columnNames);

    % Filter the table if not in allLaps mode
    if ~allLaps

        % idx = lapNumber + 1, e.g. L3 is idx 4
        summary = summary(lapNumber + 1, :);

    end
        

end
    







