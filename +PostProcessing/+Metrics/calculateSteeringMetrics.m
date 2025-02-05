function summary = calculateSteeringMetrics(runStruct, lapNumber, varargin)

    % Check nargin - <2 means lapNumber not given
    if nargin < 2

        % Create a boolean for all laps or single lap calc
        allLaps = true;

    else

        % If a lap is provided then set allLaps as false
        allLaps = false;

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
        
        % Get the derivative of steering
        steeringScalar = 225;
        dSteer = [0; diff(lapData.steerAngle .* steeringScalar) ./ dt];

        % Minimum steering derivative
        dSteerMin = min(dSteer);

        % Maximum steering derivative
        dSteerMax = max(dSteer);

        % Average steering vel (signed)
        dSteerAvg = mean(dSteer);

        % Average steering vel (absolute)
        dSteerAbsAvg = mean(abs(dSteer));

        % Percentage spent steering in each direction (L, R, C(entre))
        nPoints = size(lapData, 1);

        steerR_pct = (numel(lapData.steerAngle(lapData.steerAngle > 0.01))) / nPoints * 100;

        steerL_pct = (numel(lapData.steerAngle(lapData.steerAngle < -0.01))) / nPoints * 100; 

        steerC_pct = 100 - (steerL_pct + steerR_pct);
   

        % Populate the array
        summary(i,1) = dSteerMin;
        summary(i,2) = dSteerMax;
        summary(i,3) = dSteerAvg;
        summary(i,4) = dSteerAbsAvg;
        summary(i,5) = steerL_pct;
        summary(i,6) = steerR_pct;
        summary(i,7) = steerC_pct;


    end
        

    % Convert array to table
    columnNames = {
        'dSteerMin';...
        'dSteerMax';...
        'dSteerAvg';...
        'dSteerAbsAvg';...
        'steerL_pct';...
        'steerR_pct';...
        'steerC_pct';...

    };

    summary = array2table(summary, 'VariableNames', columnNames);
    
    % Filter the table if not in allLaps mode
    if ~allLaps

        % idx = lapNumber + 1, e.g. L3 is idx 4
        summary = summary(lapNumber + 1, :);

    end

end
    







