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

    % Loop through each lap
    for i = 1:nLaps

        % Get the data for the lap
        lapData = runStruct.data(runStruct.data.lapNumber == i - 1, :);

        % Create a lap time channel
        lapData.tLap = lapData.time - lapData.time(1);

        % Get dt
        dt = lapData.tLap(2) - lapData.tLap(1);

        % Get the derivative of CTE
        dCTE = [0; diff(lapData.CTE) ./ dt];

        % Get the derivative of abs CTE
        dACTE = [0; diff(abs(lapData.CTE)) ./ dt];

        % Get the overall integral of CTE
        TCTE = trapz(lapData.tLap, lapData.CTE);

        % Get the integral of absolute CTE
        TACTE = trapz(lapData.tLap, abs(lapData.CTE));

        % Find where absolute CTE is improving (dCTE < 0)
        rIdx = (dACTE) < -0.1;

        % Find where absolute CTE is worsening (dCTE > 0)
        wIdx = (dACTE) > 0.1;

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
        hCTE = Utilities.fnCalculateRegionWiseIntegral(lapData.tLap, abs(lapData.CTE), hRegions) / TACTE;
        % hCTE = 1 - (rCTE + wCTE);
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
        nCorrectionsCTE = Utilities.fnFindCorrections(lapData.CTE);

        % Get the number of CTE=0 crosses
        nCrossesCTE = Utilities.fnFindXCrosses(lapData.CTE);

        % Get the number of steering corrections
        nCorrectionsSteering = Utilities.fnFindCorrections(lapData.steerAngle);

        % Populate the array
        summary(i,1) = TCTE;
        summary(i,2) = TACTE;
        summary(i,3) = rCTE;
        summary(i,4) = rCTE_bias;
        summary(i,5) = wCTE;
        summary(i,6) = wCTE_bias;
        summary(i,7) = rRW;
        summary(i,8) = nCorrectionsCTE;
        summary(i,9) = nCrossesCTE;
        summary(i,10) = nCorrectionsSteering;
        summary(i,11) = rCTE_pct;
        summary(i,12) = wCTE_pct;
        summary(i,13) = hCTE_pct;
        summary(i,14) = hCTE;

    end
        

    % Convert array to table
    columnNames = {'TCTE'; 'TACTE'; 'rCTE'; 'rCTE_bias'; 'wCTE'; 'wCTE_bias'; 'rRW'; 'nCorrcectionsCTE'; 'nCrossesCTE'; 'nCorrectionsSteering'; 'rCTE_pct'; 'wCTE_pct'; 'hCTE_pct'; 'hCTE'};
    summary = array2table(summary, 'VariableNames', columnNames);
    
    % Filter the table if not in allLaps mode
    if ~allLaps

        % idx = lapNumber + 1, e.g. L3 is idx 4
        summary = summary(lapNumber + 1, :);

    end

end
    







