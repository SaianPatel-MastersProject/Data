function MSteer = calculateSteeringAggressiveness(matFilePath)
    
    load(matFilePath);
    
    % Set maximum and minimum steering angles to define normal cornering
    deltaMax = 1;
    deltaMin = 0.1;

    % Get the number of laps
    nLaps = size(runStruct.metadata.laps, 2);

    % Initialise an MSteer column
    MSteer = zeros([size(runStruct.data,1), 1]);

    % Loop through each lap
    for i = 1:nLaps

        % Get the data for the lap
        lapData = runStruct.data(runStruct.data.lapNumber == i - 1, :);

        % Create a lap time channel
        lapData.lapTime = lapData.time - lapData.time(1);

        % Get the 'cornering' data
        corneringLapData = lapData(abs(lapData.steerAngle) > deltaMin & abs(lapData.steerAngle) <= deltaMax, :);

        % Get the change in time for the corner segments
        tSegment = [0; diff(corneringLapData.lapTime)];

        % Find the corner segment changes
        iSegment = find(tSegment > 0.02);

        % Find the number of corners
        nCorners = size(iSegment,1) + 1;

        % Initialise cornerIdx array
        cornerIdx = [];

        % Handle the case when there are no corners in the lap
        if nCorners == 0

            % Create a column for this lap - filled with zeros
            MSteerLapCol = zeros([size(lapData,1), 1]);

            if i == 1

                MSteer = MSteerLapCol;

            else

                MSteer = [MSteer; MSteerLapCol];

            end

            break;

        end


        if nCorners == 1

            cornerIdx = [1, size(corneringLapData,1)];

        else

            for j = 1:nCorners

                if j == 1

                    startIdx = 1;
                    endIdx = iSegment(j);

                elseif j == nCorners

                    startIdx = iSegment(j-1) + 1;
                    endIdx = size(corneringLapData, 1);

                else

                    startIdx = iSegment(j-1) + 1;
                    endIdx = iSegment(j);

                end

                cornerIdx(j, 1) = startIdx;
                cornerIdx(j, 2) = endIdx;

            end

        end

        % Create an MSteer array for this lap
        MSteer_lap = [];

        % Loop through each corner
        for k = 1:size(cornerIdx, 1)

            cornerStartIdx = cornerIdx(k,1);
            cornerEndIdx = cornerIdx(k,2);

            % Index using corner start and end
            cornerLapData = corneringLapData(cornerStartIdx:cornerEndIdx, :);

            % Get Total cornering duration (nRows * 1/freq)
            totalCorneringDuration = size(cornerLapData,1)*0.01;

            % Get the steering angle velocity
            steerAngleVelocity = [0; diff(cornerLapData.steerAngle)];

            % Get the absolute steering angle velocity
            absSteerAngleVelocity = abs(steerAngleVelocity);

            % Integrate absolute steering angle velocity
            steeringVelocityIntegral = trapz(cornerLapData.lapTime, absSteerAngleVelocity);

            MSteer_k = (1/abs(totalCorneringDuration)) * steeringVelocityIntegral;

            MSteer_lap(k) = MSteer_k;

        end
        
        % Sum MSteer for this lap
        MSteerLapTotal = sum(MSteer_lap);

        % Create a column for this lap
        MSteerLapCol = zeros([size(lapData,1), 1]);

        % Assign all values in the column as total MSteer
        MSteerLapCol(:,1) = MSteerLapTotal; 

        if i == 1

            MSteer = MSteerLapCol;

        else

            MSteer = [MSteer; MSteerLapCol];

        end

    end
        

        

end
    







