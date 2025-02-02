classdef rFproCSVtoMAT

    % Takes an rFpro csv and turns it into a .mat
    % containing key info

    properties
        data; % The raw data from the csv, stored as a table
        metadata; % The metadata of the csv
    end

    methods

        %% Function to initiate class
        function obj = rFproCSVtoMAT(csvFilePath)
            
            % Construct an instance of this class by reading the csv
            opts = detectImportOptions(csvFilePath,'NumHeaderLines',0);
            rawData = readtable(csvFilePath, opts);

            % Specify channels to keep
            channelsToKeep = {
                'time';...
                'lapDist';...
                'sLapRef';...
                'lapNumber';...
                'speed';...
                'posX';...
                'posY';...
                'posZ';...
                'rotX';...
                'rotY';...
                'rotZ';...
                'throttle';...
                'brake';...
                'steerAngle';...
                'gear';...
                'Distance';...
            };

            obj.data = rawData(:, channelsToKeep');

            % Get the number of laps in the run
            lapsInRun = unique(obj.data.lapNumber);
            nLaps = numel(lapsInRun);

            for i = 1:nLaps

                % Get lapData
                lapData = obj.data(obj.data.lapNumber == lapsInRun(i), :);

                % Only fix stutters for flying laps
                if and(i > 1, i < nLaps)

                    % Remove stutters (lap-by-lap basis)
                    [~, stutterIdx] = PostProcessing.Stutter.fnDetectStutters(lapData);
                    lapData = PostProcessing.Stutter.fnFixStutters(lapData, stutterIdx, 100);

                end

                % Stack the data
                if i == 1
                
                    newData = lapData;

                else

                    newData = [newData; lapData];


                end

            end

            % Overwrite with stutter fix
            obj.data = newData;
            
            % Overwrite lap numbers - only if there is a mismatch
            obj = obj.correctLaps();

            % Store the filepath
            obj.metadata.filePath = csvFilePath;

            % Store the filename as the ID
            [~, obj.metadata.runName, ~] = fileparts(csvFilePath);

        end

        %% Function to get run metadata and important info
        function obj = getRunInfo(obj, track)

            % Store the filename as the ID
            [~, obj.metadata.runName, ~] = fileparts(obj.metadata.filePath);

            % Store track name
            if isempty(track)

                obj.metadata.track = extractBefore(obj.metadata.runName, '-');

            else

                obj.metadata.track = track;

            end

            % Store run date
            dateString = char(extractBetween(obj.metadata.runName, '-', '_'));

            % Store the year
            obj.metadata.year = dateString(1:4);

            % Convert dateString to dateNum
            dateNum = datenum(dateString, 'yyyymmdd');

            % Get Monday datenum for that week
            dayOfWeek = weekday(dateNum);
            if dayOfWeek == 2
                monday = dateNum;
            elseif dayOfWeek == 1
                
                % Get previous Monday if current day is Sunday
                monday = dateNum - (dayOfWeek - 2 + 7);

            else
                monday = dateNum - (dayOfWeek - 2);
            end

            % Format monday as mm_dd
            mondayDateString = datestr(monday, 'mm_dd');

            % Store the event
            obj.metadata.event = ['FYP', mondayDateString];

            % Store the day (D1 = Monday, D7 = Sunday)
            day = dayOfWeek - 1;
            if day == 0
                day = 7;
            end
            obj.metadata.day = sprintf('D%i', day);

            % Store run time
            obj.metadata.time = extractAfter(obj.metadata.runName, '_');

        end

        %% Function to set a run description
        function obj = setRunDescription(obj, runDescription)

            % Store the specified run description
            obj.metadata.description = runDescription;

        end

        %% Function to set the run number
        function obj = setRunNumber(obj, runNumber)

            % Store the specified run description
            if runNumber < 10

                obj.metadata.runNumber = sprintf('R0%i', runNumber);

            else

                obj.metadata.runNumber = sprintf('R%i', runNumber);

            end
        end

        %% Function to set unique ID
        function obj = setUniqueIdentifier(obj)

            % Store a unique ID by combining Event, Day and Run Number
            obj.metadata.runID = sprintf('%s_%s_%s_%s', obj.metadata.year, obj.metadata.event, obj.metadata.day, obj.metadata.runNumber);

        end

        %% Function to set the driver info
        function obj = setDriverName(obj, driverName)

            % Set the driver name
            obj.metadata.driver = driverName;

        end

        %% Function to set the vehicle model description
        function obj = setVehicleModel(obj, vehicleModel)

            % Set the driver name
            obj.metadata.vehicleModel = vehicleModel;

        end
        %% Function to get some info on the data
        function obj = getDataInfo(obj)

            % Get a list of channels in the data
            obj.metadata.channels = (obj.data.Properties.VariableNames)';

            % Get the sampling frequency
            timeStep = diff(obj.data.time);
            obj.metadata.sampleFrequency = 1/(timeStep(1));

        end

        %% Function to get some info on the laps
        function obj = getLapInfo(obj)

            % Get a list of lap numbers in the run
            lapNumbers = unique(obj.data.lapNumber);

            % Count the number of laps
            nLaps = numel(lapNumbers);

            lapTimes = [];

            for i = 1:nLaps

                % Read data for this lap
                lapData = obj.data(obj.data.lapNumber == lapNumbers(i), :);

                % Calculate the lap time for this lap
                lapTimes(i) = lapData.time(end) - lapData.time(1);

            end

            lapTimes = lapTimes';

            if nLaps == 1
                
                % Set lapType to 0 for Out Laps
                lapTypes = 0;

            elseif nLaps == 2

                % Set lapType to 2 for In Laps
                lapTypes = [0; 2];

            else

                % Set lapType to 1 for Flying Laps
                lapTypes = ones([nLaps, 1]);
                lapTypes(1) = 0;
                lapTypes(end) = 2;
                

            end

            % Create laps struct array
            obj.metadata.laps = struct('lapNumber', [], 'lapTime', [], 'lapType', []);

            % Iteratively fill the laps struct array
            for i = 1:nLaps

                obj.metadata.laps(i).lapNumber = lapNumbers(i);
                obj.metadata.laps(i).lapTime = lapTimes(i);
                obj.metadata.laps(i).lapType = lapTypes(i);

            end
            
            % Find the fastest lap
            if nLaps <= 2

                % Just get the minimum lap time of all available laps
                [~, fastestLapIdx] = min(lapTimes);

            else

                % Filter by only flying laps
                [fastestLapTime, ~] = min(lapTimes(lapTypes == 1));
                fastestLapIdx = find(lapTimes == fastestLapTime);

            end

            % Populate the fastest lap struct array
            obj.metadata.fastestLap.lapNumber = lapNumbers(fastestLapIdx);
            obj.metadata.fastestLap.lapTime = lapTimes(fastestLapIdx);
            obj.metadata.fastestLap.lapType = lapTypes(fastestLapIdx);

        end

        %% Function to save the data
        function obj = saveData(obj)

            % Get the folder that the data should belong to
            eventFolder = fullfile('+ProcessedData', obj.metadata.year, obj.metadata.event);
            
            % Check that the folder exists
            if ~isfolder(eventFolder)

                sprintf('Event folder (%s) does not exist.', eventFolder);
                
                fprintf('Trying previous year.');

                eventFolder = strrep(eventFolder, '2025', '2024');

                if ~isfolder(eventFolder)
                    sprintf('Event folder (%s) does not exist.', eventFolder);
                    return;
                end

            end

            % Set the .mat filename
            matFileName = sprintf('%s.mat', obj.metadata.runID);

            % Set the .mat filepath
            matFilePath = fullfile(eventFolder, matFileName);

            % Store the matFilePath
            obj.metadata.matFilePath = matFilePath;

            % Create a dummy object
            runStruct = obj;

            % Save the .mat
            save(matFilePath, 'runStruct');


        end

        %% Function to correct lap numbers
        function obj = correctLaps(obj)

            % Get the number of laps in the run
            lapsInRun = unique(obj.data.lapNumber);
            nLaps = numel(lapsInRun);

            % Get x and y
            x = obj.data.posX;
            y = obj.data.posY;

            % Specify a manual timing plane
            xL = -260;
            yL = -1.715;
            xR = -230;
            yR = -1.715;

            intersections = []; % Store intersection points

            % Iterate through trajectory segments
            for i = 1:length(x)-1
                % Line segment endpoints
                x1 = x(i); y1 = y(i);
                x2 = x(i+1); y2 = y(i+1);

                % Solve for intersection using determinant method
                A = [x2 - x1, xL - xR; y2 - y1, yL - yR];
                B = [xL - x1; yL - y1];

                if det(A) == 0  % Lines are parallel
                    continue;
                end

                % Solve for t and u
                T = A \ B;  % Equivalent to inv(A) * B but faster

                t = T(1);
                u = T(2);

                % Check if intersection is within both segments (0 ≤ t ≤ 1 and 0 ≤ u ≤ 1)
                if (t >= 0 && t <= 1) && (u >= 0 && u <= 1)
                    % Compute intersection point
                    xi = x1 + t * (x2 - x1);
                    yi = y1 + t * (y2 - y1);
                    intersections = [intersections; xi, yi, i]; %#ok<AGROW>
                end
            end

            % Get the number of intersections
            nIntersections = size(intersections, 1);

            % If the number of intersections is more than the number of
            % laps recorded, then correct the laps
            if nIntersections+1 > nLaps

                % Throw warning
                warning('Using interesctions to correct lap numbers.')

                lap = 0;
    
                for i = 1:nIntersections
    
                    if i == 1
                    
                        obj.data.lapNumber(1:intersections(i,3)) = lap;
    
                    else
    
                        obj.data.lapNumber(intersections(i-1,3)+1:intersections(i,3)) = lap;
    
                    end
    
                    lap = lap + 1;
    
                end
    
                % Set the final lap
                obj.data.lapNumber(intersections(end,3)+1:end) = lap;

            end


        end

    end
end