function summary = calculateCTEMetrics(runStruct)

    % Get the matfilepath
    matFilePath = runStruct.metadata.matFilePath;

    % Read in CTE layers if they exist
    % CTEmatFilePath = strrep(matFilePath, '.mat', '_CTE.mat');
    % 
    % if isfile(CTEmatFilePath)
    % 
    %     % Load the CTE layer
    %     load(CTEmatFilePath)
    % 
    %     % Join CTE layer to the data for the run
    %     runStruct.data = addvars(runStruct.data, dataCTE.CTE, 'NewVariableNames', 'CTE');
    %     runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointX, 'NewVariableNames', 'closestWaypointX');
    %     runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointY, 'NewVariableNames', 'closestWaypointY');
    % 
    % 
    % end

    % Read in PE layers if they exist
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

        % Get the derivative of CTE
        dCTE = [0; diff(lapData.CTE) ./ dt];

        % Get the derivative of abs CTE
        dACTE = [0; diff(abs(lapData.CTE)) ./ dt];

        % Get the overall integral of CTE
        TCTE = trapz(lapData.tLap, lapData.CTE);

        % Get the integral of absolute CTE
        TACTE = trapz(lapData.tLap, abs(lapData.CTE));

        % Find where absolute CTE is improving (dCTE < 0)
        rIdx = [(dACTE) < 0];

        % Find where absolute CTE is worsening (dCTE > 0)
        wIdx = [(dACTE) > 0];

        % Get the improvement intergal (signed and unsigned)
        % rCTE_signed = trapz(lapData.tLap(rIdx), lapData.CTE(rIdx));
        % rCTE = trapz(lapData.tLap(rIdx), abs(lapData.CTE(rIdx)));
        rRegions = fnFindContinuousRegions(rIdx);
        rCTE_signed = fnCalculateRegionWiseIntegral(lapData.tLap, lapData.CTE, rRegions);
        rCTE = fnCalculateRegionWiseIntegral(lapData.tLap, abs(lapData.CTE), rRegions);


        % Get the worsening intergal (signed and unsigned)
        % wCTE_signed = trapz(lapData.tLap(wIdx), lapData.CTE(wIdx));
        % wCTE = trapz(lapData.tLap(wIdx), abs(lapData.CTE(wIdx)));
        wRegions = fnFindContinuousRegions(wIdx);
        wCTE_signed = fnCalculateRegionWiseIntegral(lapData.tLap, lapData.CTE, wRegions);
        wCTE = fnCalculateRegionWiseIntegral(lapData.tLap, abs(lapData.CTE), wRegions);

        % Populate the array
        summary(i,1) = TCTE;
        summary(i,2) = TACTE;
        summary(i,3) = rCTE;
        summary(i,4) = rCTE_signed;
        summary(i,5) = wCTE;
        summary(i,6) = wCTE_signed;

    end
        

    % Convert array to table
    columnNames = {'TCTE'; 'TACTE'; 'rCTE'; 'rCTE_signed'; 'wCTE'; 'wCTE_signed'};
    summary = array2table(summary, 'VariableNames', columnNames);
        

end
    







