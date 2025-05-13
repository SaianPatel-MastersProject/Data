function summary = calculateCTEMetrics(runStruct, lapNumber, varargin)

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
    if ~ismember(tableColumns, 'CTE')

        % Get the matfilepath
        matFilePath = runStruct.metadata.matFilePath;

        % Read in PE/CTE layers if they exist
        PEmatFilePath = strrep(matFilePath, '.mat', '_PE.mat');
        CTEmatFilePath = strrep(matFilePath, '.mat', '_CTE.mat');

        if isfile(PEmatFilePath)

            % Load the CTE layer
            load(PEmatFilePath)

            % Join CTE layer to the data for the run
            runStruct.data = addvars(runStruct.data, dataPE.CTE, 'NewVariableNames', 'CTE');
            runStruct.data = addvars(runStruct.data, dataPE.closestWaypointX, 'NewVariableNames', 'closestWaypointX');
            runStruct.data = addvars(runStruct.data, dataPE.closestWaypointY, 'NewVariableNames', 'closestWaypointY');
            runStruct.data = addvars(runStruct.data, dataPE.HeadingError, 'NewVariableNames', 'HeadingError');

        else
    
            if isfile(CTEmatFilePath)

                % Load the CTE layer
                load(CTEmatFilePath)

                % Join CTE layer to the data for the run
                runStruct.data = addvars(runStruct.data, dataCTE.CTE, 'NewVariableNames', 'CTE');
                runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointX, 'NewVariableNames', 'closestWaypointX');
                runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointY, 'NewVariableNames', 'closestWaypointY');

            end

        end
    
        
    end

    % Check again if CTE exists
    tableColumns = runStruct.data.Properties.VariableNames;

    if ~ismember(tableColumns, 'CTE')

        sprintf('No CTE data found for: %s. \n', runStruct.metadata.runID);

    end

    % Get the number of laps
    nLaps = size(runStruct.metadata.laps, 2);

    % Create a summary array
    summary = zeros([nLaps, 6]);

    % Create a lap time channel
    runStruct.data.tLap = runStruct.data.time - runStruct.data.time(1);

    % Get the integral of absolute CTE
    runData = runStruct.data(runStruct.data.lapNumber > 0 , :);
    lapsInRun = unique(runStruct.data.lapNumber);
    runData = runData(runData.lapNumber < lapsInRun(end), :);
    % TACTE_concat = (1 / runStruct.data.tLap(end)) * trapz(runStruct.data.tLap, abs(runStruct.data.CTE));
    TACTE_concat = (1 / runData.tLap(end)) * trapz(runData.tLap, abs(runData.CTE));

    % Loop through each lap
    for i = 1:nLaps

        % Get the data for the lap
        % lapData = runStruct.data(runStruct.data.lapNumber == i - 1, :);
        lapData = runStruct.data(runStruct.data.lapNumber == runStruct.metadata.laps(i).lapNumber, :);

        % Create a lap time channel
        lapData.tLap = lapData.time - lapData.time(1);
        lapTime = lapData.tLap(end);

        % Get dt
        dt = lapData.tLap(2) - lapData.tLap(1);

        % Get the derivative of CTE
        dCTE = [0; diff(lapData.CTE) ./ dt];

        % Get the derivative of abs CTE
        dACTE = [0; diff(abs(lapData.CTE)) ./ dt];

        % Filter dACTE
        dACTE = movmean(dACTE, 51);

        % Get the overall integral of CTE
        TCTE = trapz(lapData.tLap, lapData.CTE);

        % Get the integral of absolute CTE
        TACTE = (1 / lapData.tLap(end)) * trapz(lapData.tLap, abs(lapData.CTE));
        % TACTE = trapz(lapData.tLap, abs(lapData.CTE));

        % Find where absolute CTE is improving (dCTE < 0)
        rIdx = (dACTE) < -0.05;

        % Find where absolute CTE is worsening (dCTE > 0)
        wIdx = (dACTE) > 0.05;

        % Find where absolute CTE is held
        hIdx = and(~rIdx, ~wIdx);
        % hIdx = (dACTE) > -0.1 & (dACTE) < 0.1;

        % Get the improvement intergal (signed and unsigned)
        rRegions = Utilities.fnFindContinuousRegions(rIdx);
        rCTE_bias = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, lapData.CTE, rRegions);
        rCTE = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, abs(lapData.CTE), rRegions) / TACTE;
        rCTE_pct = (sum(rIdx)/length(rIdx))*100;

        % Get the worsening intergal (signed and unsigned)
        wRegions = Utilities.fnFindContinuousRegions(wIdx);
        wCTE_bias = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, lapData.CTE, wRegions);
        wCTE = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, abs(lapData.CTE), wRegions) / TACTE;
        wCTE_pct = (sum(wIdx)/length(wIdx))*100;

        % Get the held intergal (signed and unsigned)
        hRegions = Utilities.fnFindContinuousRegions(hIdx);
        hCTE_bias = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, lapData.CTE, hRegions);
        % hCTE = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, abs(lapData.CTE), hRegions) / TACTE;
        hCTE = 100 - (rCTE + wCTE);
        hCTE_pct = 100 - (rCTE_pct + wCTE_pct);

        % Sanity plot
        % figure("Name", 'Sanity Check');
        % hold on
        % plot(lapData.tLap, lapData.CTE, 'LineStyle','--', 'Color', 'black');
        % scatter(lapData.tLap(rIdx), lapData.CTE(rIdx), 'filled', 'MarkerFaceColor', 'green');
        % scatter(lapData.tLap(wIdx), lapData.CTE(wIdx), 'filled', 'MarkerFaceColor', 'red');
        % scatter(lapData.tLap(hIdx), lapData.CTE(hIdx), 'filled', 'MarkerFaceColor', 'blue');


        % Calculate r_r,w
        rRW = rCTE / (rCTE + wCTE);

        % Get the number of CTE corrections
        nCorrectionsCTE = Utilities.fnFindCorrections(movmean(lapData.CTE,51));

        % Get the number of CTE=0 crosses
        [nCrossesCTE, ~] = Utilities.fnFindXCrosses(lapData.CTE);

        % Get the number of steering corrections
        nCorrectionsSteering = Utilities.fnFindCorrections(lapData.steerAngle);

        
        % Get the pos and neg deadzone means
        if i == 1 || i == lapsInRun(end)+1

            steeringDeadzoneData.posMean = 0;
            steeringDeadzoneData.negMean = 0;

        else
            steeringDeadzoneData = Utilities.fnSteeringDeadzone(lapData, 400);

        end

        % Populate the array
        summary(i,1) = TCTE;
        summary(i,2) = TACTE;
        summary(i,3) = mean(lapData.CTE);
        summary(i,4) = mean(abs(lapData.CTE));
        summary(i,5) = rCTE;
        summary(i,6) = wCTE;
        summary(i,7) = hCTE;
        summary(i,8) = rRW;
        summary(i,9) = rCTE_bias;
        summary(i,10) = wCTE_bias;
        summary(i,11) = hCTE_bias;
        summary(i,12) = rCTE_pct;
        summary(i,13) = wCTE_pct;
        summary(i,14) = hCTE_pct;
        summary(i,15) = nCorrectionsCTE;
        summary(i,16) = nCrossesCTE;
        summary(i,17) = nCorrectionsSteering;
        summary(i,18) = TACTE_concat;
        summary(i,19) = lapTime;
        summary(i,20) = steeringDeadzoneData.posMean;
        summary(i,21) = steeringDeadzoneData.negMean;

    end
        

    % Convert array to table
    columnNames = {
        'TCTE';...
        'TACTE';...
        'CTE_avg';...
        'ACTE_avg';...
        'rCTE';...
        'wCTE';...
        'hCTE';...
        'rRW';...
        'rCTE_bias';...
        'wCTE_bias';...
        'hCTE_bias';...
        'rCTE_pct';...
        'wCTE_pct';...
        'hCTE_pct';...
        'nCorrectionsCTE';...
        'nCrossesCTE';...
        'nCorrectionSteering';...
        'TACTE_Concat';...
        'LapTime'; ...
        'DeadzonePosMean';...
        'DeadzoneNegMean';
    };

    summary = array2table(summary, 'VariableNames', columnNames);
    
    % Filter the table if not in allLaps mode
    if ~allLaps

        % idx = lapNumber + 1, e.g. L3 is idx 4
        summary = summary(lapNumber + 1, :);

    end

end
    







