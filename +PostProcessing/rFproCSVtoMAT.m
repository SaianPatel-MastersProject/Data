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
                'throttle';...
                'brake';...
                'steerAngle';...
                'gear';...
                'Distance';...
            };

            obj.data = rawData(:, channelsToKeep');

            % Store the filepath
            obj.metadata.filePath = csvFilePath;

            % Store the filename as the ID
            [~, obj.metadata.runName, ~] = fileparts(csvFilePath);

        end

        %% Function to get run metadata and important info
        function obj = getRunInfo(obj)

            % Store the filename as the ID
            [~, obj.metadata.runName, ~] = fileparts(obj.metadata.filePath);

            % Store track name
            obj.metadata.track = extractBefore(obj.metadata.runName, '-');

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
        function saveData(obj)

            % Get the folder that the data should belong to
            eventFolder = fullfile('+ProcessedData', obj.metadata.year, obj.metadata.event);
            
            % Check that the folder exists
            if ~isdir(eventFolder)

                display('Event folder does not exist.');
                return;

            end

            % Set the .mat filename
            matFileName = sprintf('%s.mat', obj.metadata.runName);

            % Set the .mat filepath
            matFilePath = fullfile(eventFolder, matFileName);

            % Create a dummy object
            runStruct = obj;

            % Save the .mat
            save(matFilePath, 'runStruct');


        end

    end
end