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

            % Read in CTE layers if they exist
            CTEmatFilePath = strrep(matFilePath, '.mat', '_CTE.mat');

            if isfile(CTEmatFilePath)

                % Load the CTE layer
                load(CTEmatFilePath)

                % Join CTE layer to the data for the run
                runStruct.data = addvars(runStruct.data, dataCTE.CTE, 'NewVariableNames', 'CTE');
                runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointX, 'NewVariableNames', 'closestWaypointX');
                runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointY, 'NewVariableNames', 'closestWaypointY');


            end

            % Read in VE layers if they exist
            VEmatFilePath = strrep(matFilePath, '.mat', '_VE.mat');

            if isfile(VEmatFilePath)

                % Load the CTE layer
                load(VEmatFilePath)

                % Join CTE layer to the data for the run
                runStruct.data = addvars(runStruct.data, dataVE.vError, 'NewVariableNames', 'vError');
                runStruct.data = addvars(runStruct.data, dataVE.refVel, 'NewVariableNames', 'refVel');
                runStruct.data = addvars(runStruct.data, dataVE.rCurvature, 'NewVariableNames', 'rCurvature');


            end

            % Fetch the data for the selected lap
            lapData = runStruct.data(runStruct.data.lapNumber == lapNumber, :);

            % Add a tLap Channel
            lapData = addvars(lapData, (lapData.time - lapData.time(1)), 'NewVariableNames', 'tLap');

            % Check current number of entries in the struct
            nEntries = size(obj.data, 2);

            if isempty(obj.data(1).lapNumber)

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

                plot(obj.data(i).lapData.sLapRef, obj.data(i).lapData.speed * 3.6);

            end
            
            xlabel('sLap');
            ylabel('Speed (km/h)');
            
            %% Plot Throttle Application
            subplot(4,1,2);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.sLapRef, obj.data(i).lapData.throttle);

            end

            xlabel('sLap');
            ylabel('Throttle');
            
            %% Plot Brake Application
            subplot(4,1,3);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.sLapRef, obj.data(i).lapData.brake);

            end

            xlabel('sLap');
            ylabel('Brake');
            
            %% Plot Steering Angle
            subplot(4,1,4);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.sLapRef, obj.data(i).lapData.steerAngle);

            end

            xlabel('sLap');
            ylabel('Steering Angle');
            
            %% Link Axes
            linkaxes(findall(gcf,'Type','axes'), 'x');

        end
        
        %% Function for plotting racing line
        function plotRacingLine(obj)

            nLaps = size(obj.data, 2);

            figure;

            axis equal

            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.posX, obj.data(i).lapData.posY);

            end

            xlabel('X Position');
            ylabel('Y Position');
            

        end

        %% Function for plotting CTE
        function plotCTE(obj)

            nLaps = size(obj.data, 2);
           
            figure;

            subplot(2,1,1);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.sLapRef, obj.data(i).lapData.CTE);

            end

            xlabel('Lap Distance Along Reference');
            ylabel('CTE');
            
            subplot(2,1,2);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, obj.data(i).lapData.CTE);

            end

            xlabel('Lap Time (s)');
            ylabel('CTE');

        end
    
    end
end