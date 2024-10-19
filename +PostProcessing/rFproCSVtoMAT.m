classdef rFproCSVtoMAT

    % Takes an rFpro csv and turns it into a .mat
    % containing key info

    properties
        data; % The raw data from the csv, stored as a table
        metadata; % The metadata of the csv
    end

    methods

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
            [~, obj.metadata.runID, ~] = fileparts(csvFilePath);

        end

        function obj = getRunInfo(obj)

            % Store the filename as the ID
            [~, obj.metadata.runID, ~] = fileparts(obj.metadata.filePath);

            % Store track name
            obj.metadata.track = extractBefore(obj.metadata.runID, '-');

            % Store run date
            obj.metadata.date = char(extractBetween(obj.metadata.runID, '-', '_'));

            % Store run time
            obj.metadata.time = extractAfter(obj.metadata.runID, '_');

        end

        function obj = getDataInfo(obj)

            % Get a list of channels in the data
            obj.metadata.channels = (obj.data.Properties.VariableNames)';

            % Get the sampling frequency
            timeStep = diff(obj.data.time);
            obj.metadata.sampleFrequency = 1/(timeStep(1));

        end

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

        function saveData(obj)

            % Set the .mat filename
            matFileName = sprintf('+ProcessedData/%s.mat', obj.metadata.runID);

            % Create a dummy object
            runStruct = obj;

            % Save the .mat
            save(matFileName, 'runStruct');


        end

    end
end