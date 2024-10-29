classdef multiPlotter

    % Class to plot multiple laps

    properties

        data; % Struct array of lap-by-lap data
        

    end

    methods
        function obj = multiPlotter()

            % Construct class
            obj.data = struct('runID', '', 'lapNumber', [], 'lapData', table);

        end

        function obj = addLap(obj, matFilePath, lapNumber)

            % Read in a run .mat file
            load(matFilePath);

            % Get the runID
            runID = runStruct.metadata.runID;

            % Fetch the data for the selected lap
            lapData = runStruct.data(runStruct.data.lapNumber == lapNumber, :);

            % Check current number of entries in the struct
            nEntries = size(obj.data, 2);

            if isempty(obj.data.lapNumber)

                i = 1;

            else

                i = nEntries + 1;

            end

            % Populate the struct
            obj.data(i).runID = runID;
            obj.data(i).lapNumber = lapNumber;
            obj.data(i).lapData = lapData;
            
        end

        function plotFundamentals(obj)
            
            figure; % Create a fundamentals figure
            
            nLaps = size(obj.data, 2);

            %% Plot Car Speed - Speed
            subplot(4,1,1);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.speed * 3.6);

            end
            
            xlabel('sLap');
            ylabel('Speed (km/h)');
            
            %% Plot Throttle Application
            subplot(4,1,2);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.throttle);

            end

            xlabel('sLap');
            ylabel('Throttle');
            
            %% Plot Brake Application
            subplot(4,1,3);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.brake);

            end

            xlabel('sLap');
            ylabel('Brake');
            
            %% Plot Steering Angle
            subplot(4,1,4);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.steerAngle);

            end

            xlabel('sLap');
            ylabel('Steering Angle');
            
            %% Link Axes
            linkaxes(findall(gcf,'Type','axes'), 'x');

        end
    end
end