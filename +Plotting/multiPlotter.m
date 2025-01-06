classdef multiPlotter

    % Class to plot multiple laps

    properties

        data; % Struct array of lap-by-lap data
        plottingTools; % Info for plotting
        

    end

    methods
        function obj = multiPlotter()

            % Construct class
            obj.data = struct('runID', '', 'lapNumber', [], 'lapData', table, 'track', '', 'driver', '', 'metricsCTE', table, 'metricsHE', table);
            obj.plottingTools = struct();

        end

        function obj = addLap(obj, matFilePath, lapNumber)

            % Read in a run .mat file
            load(matFilePath);

            % Get the track
            track = runStruct.metadata.track;

            % Get the runID
            runID = runStruct.metadata.runID;

            % Get the driver
            driver = runStruct.metadata.driver;

            %% Read in CTE layers if they exist
            % CTEmatFilePath = strrep(matFilePath, '.mat', '_CTE.mat');

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

            %% Read in PE layers if they exist
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

            %% Read in VE layers if they exist
            VEmatFilePath = strrep(matFilePath, '.mat', '_VE.mat');

            if isfile(VEmatFilePath)

                % Load the CTE layer
                load(VEmatFilePath)

                % Join CTE layer to the data for the run
                runStruct.data = addvars(runStruct.data, dataVE.vError, 'NewVariableNames', 'vError');
                runStruct.data = addvars(runStruct.data, dataVE.refVel, 'NewVariableNames', 'refVel');
                runStruct.data = addvars(runStruct.data, dataVE.rCurvature, 'NewVariableNames', 'rCurvature');


            end

            %% Read in ProMoD layers if they exist
            ProMoDmatFilePath = strrep(matFilePath, '.mat', '_ProMoD.mat');

            if isfile(ProMoDmatFilePath)

                % Load the CTE layer
                load(ProMoDmatFilePath)

                % Join CTE layer to the data for the run
                runStruct.data = addvars(runStruct.data, dataProMoD.MSteer, 'NewVariableNames', 'MSteer');

            end

            %% Fetch the data for the selected lap
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

            %% Get the CTE metrics summary
            obj.data(i).metricsCTE = PostProcessing.CTE.calculateCTEMetrics(runStruct, lapNumber);

            %% Get the Heading Error metrics sumamry
            obj.data(i).metricsHE = PostProcessing.PE.calculateHeadingErrorMetrics(runStruct, lapNumber);

            %% Populate the struct
            obj.data(i).runID = runID;
            obj.data(i).lapNumber = lapNumber;
            obj.data(i).lapData = lapData;
            obj.data(i).track = track;
            obj.data(i).driver = driver;

            %% Update Plotting Tools based on the added lap
            obj = obj.updateLegendCell();
            
        end

        function obj = updateLegendCell(obj)

            nLaps = size(obj.data, 2);

            legendCell = {};

            for i = 1:nLaps

                % Get the runIDs and Laps for legend
                legend_i = sprintf('%s - L%i - %s', strrep(obj.data(i).runID, '_', '\_'), obj.data(i).lapNumber, obj.data(i).driver);

                % Populate the cell
                if isempty(legendCell)

                    legendCell{1} = legend_i;

                else

                    legendCell{end+1} = legend_i;

                end

            end

            % Save the legendCell
            obj.plottingTools.legendCell = legendCell;



        end
        function plotFundamentals(obj)
            
            figure("Name", 'Fundamentals'); % Create a fundamentals figure
            
            nLaps = size(obj.data, 2);

            %% Plot Car Speed - Speed
            subplot(4,1,1);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.sLapRef, obj.data(i).lapData.speed * 3.6);

            end
            
            xlabel('sLap');
            ylabel('Speed (km/h)');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            
            %% Plot Throttle Application
            subplot(4,1,2);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.sLapRef, obj.data(i).lapData.throttle);

            end

            xlabel('sLap');
            ylabel('Throttle');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            
            %% Plot Brake Application
            subplot(4,1,3);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.sLapRef, obj.data(i).lapData.brake);

            end

            xlabel('sLap');
            ylabel('Brake');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            
            %% Plot Steering Angle
            subplot(4,1,4);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.sLapRef, obj.data(i).lapData.steerAngle);

            end

            xlabel('sLap');
            ylabel('Steering Angle');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            
            %% Link Axes
            linkaxes(findall(gcf,'Type','axes'), 'x');

        end

         %% Function for plotting dSteeringAngle
         function plotDerivativesSteeringAngle(obj)

             nLaps = size(obj.data, 2);

             figure("Name", 'Steering & Derivatives');

             steeringScalar = 225;

             subplot(3,1,1);
             hold on

             for i = 1:nLaps

                 plot(obj.data(i).lapData.tLap, obj.data(i).lapData.steerAngle * steeringScalar);

             end

             xlabel('Lap Time (s)');
             ylabel('Steering Angle (°)');
             legend(obj.plottingTools.legendCell);
             grid;
             grid minor;

             subplot(3,1,2);
             hold on

             for i = 1:nLaps

                 % Get dt
                 dt = obj.data(i).lapData.tLap(2) - obj.data(i).lapData.tLap(1);
                 dSteerAngle = [0; diff(obj.data(i).lapData.steerAngle .* steeringScalar)./ dt];
                 plot(obj.data(i).lapData.tLap, dSteerAngle);

             end

             xlabel('Lap Time (s)');
             ylabel('First Derivative of Steering Angle');
             grid;
             grid minor;

             subplot(3,1,3);
             hold on

             for i = 1:nLaps

                 % Get dt
                 dt = obj.data(i).lapData.tLap(2) - obj.data(i).lapData.tLap(1);
                 dSteerAngle = [0; diff(obj.data(i).lapData.steerAngle .* steeringScalar)./ dt];
                 ddSteerAngle = [0; diff(dSteerAngle)./ dt];

                 plot(obj.data(i).lapData.tLap, ddSteerAngle);

             end

             xlabel('Lap Time (s)');
             ylabel('Second Derivative of Steer Angle');
             grid;
             grid minor;

             %% Link Axes
             linkaxes(findall(gcf,'Type','axes'), 'x');
         end
      
        %% Function for plotting racing line
        function plotRacingLine(obj, plotAIW)

            nLaps = size(obj.data, 2);

            figure("Name", 'Racing Line');

            axis equal

            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.posX, obj.data(i).lapData.posY, 'LineWidth', 2);

            end

             % Plot the reference AIW if specified
            if plotAIW

                switch obj.data(1).track
                    case 'Arrow Speedway'

                        AIW_Table = readtable('+PostProcessing\+CTE\Arrow.csv');

                    case '2kFlat'

                        AIW_Table = readtable('+PostProcessing\+CTE\2kFlat.csv');

                    otherwise

                        % Track not recognised
                        return;

                end

                nPoints  = 10000;
                interpMethod = 'spline';
                
                AIW_Data = [AIW_Table.x, AIW_Table.y];
                dBetweenPoints = (sqrt(diff(AIW_Data(:,1)).^2 + diff(AIW_Data(:,2)).^2));
                rollingDistance = [0; cumsum(dBetweenPoints)];
                dNew = (linspace(0, rollingDistance(end), nPoints))';
                xInterp = interp1(rollingDistance, AIW_Data(:,1), dNew, interpMethod);
                yInterp = interp1(rollingDistance, AIW_Data(:,2), dNew, interpMethod);
                AIW_Data = [xInterp, yInterp];

                plot(AIW_Data(:,1), AIW_Data(:,2), 'LineStyle','--', 'Color', 'black', 'LineWidth', 1);

            end

            xlabel('X Position');
            ylabel('Y Position');
            title('Racing Lines')
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;

        end

        %% Function for plotting CTE
        function plotCurvature(obj)

            nLaps = size(obj.data, 2);
           
            figure;

            subplot(2,1,1);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.lapDist, 1 ./ obj.data(i).lapData.rCurvature);

            end

            xlabel('Lap Distance (m)');
            ylabel('Curvature \kappa');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            
            subplot(2,1,2);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.steerAngle);

            end

            xlabel('Lap Distance (m)');
            ylabel('Steer Angle');
            grid;
            grid minor;


        end

         %% Function for plotting dCTE
        function plotDerivativesCTE(obj)

            nLaps = size(obj.data, 2);
           
            figure("Name", 'CTE & Derivatives');

            subplot(3,1,1);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, obj.data(i).lapData.CTE);

            end

            xlabel('Lap Time (s)');
            ylabel('CTE (m)');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;

            subplot(3,1,2);
            hold on

            for i = 1:nLaps

                % Get dt
                dt = obj.data(i).lapData.tLap(2) - obj.data(i).lapData.tLap(1);
                dCTE = [0; (diff(obj.data(i).lapData.CTE))./ dt];
                plot(obj.data(i).lapData.tLap, dCTE);

            end

            xlabel('Lap Time (s)');
            ylabel('First Derivative of CTE');
            grid;
            grid minor;
            
            subplot(3,1,3);
            hold on

            for i = 1:nLaps

                % Get dt
                dt = obj.data(i).lapData.tLap(2) - obj.data(i).lapData.tLap(1);
                dCTE = [0; diff(obj.data(i).lapData.CTE)./ dt];
                ddCTE = [0; diff(dCTE)./ dt];

                plot(obj.data(i).lapData.tLap, ddCTE);

            end

            xlabel('Lap Time (s)');
            ylabel('Second Derivative of CTE');
            grid;
            grid minor;

            %% Link Axes
            linkaxes(findall(gcf,'Type','axes'), 'x');


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
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            
            subplot(2,1,2);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, obj.data(i).lapData.CTE);

            end

            xlabel('Lap Time (s)');
            ylabel('CTE');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;


        end
    
        %% Function for plotting CTE Metrics
        function plotMetricsCTE(obj)

            figure("Name", 'CTE Metrics'); % Create a CTE Metrics figure
            
            nLaps = size(obj.data, 2);

            % TACTE vs rCTE
            subplot(2,2,1);
            hold on

            for i = 1:nLaps

                scatter(obj.data(i).metricsCTE.TACTE, obj.data(i).metricsCTE.rCTE, 'filled');

            end

            xlabel('Total Absolute CTE');
            ylabel('Improving Absolute CTE');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;

            % TACTE vs wCTE
            subplot(2,2,2);
            hold on

            for i = 1:nLaps

                scatter(obj.data(i).metricsCTE.TACTE, obj.data(i).metricsCTE.wCTE, 'filled');

            end

            xlabel('Total Absolute CTE');
            ylabel('Worsening Absolute CTE');
            grid;
            grid minor;

            % rCTE vs wCTE
            subplot(2,2,3);
            hold on

            for i = 1:nLaps

                scatter(obj.data(i).metricsCTE.rCTE, obj.data(i).metricsCTE.wCTE, 'filled');

            end

            xlabel('Improving Absolute CTE');
            ylabel('Worsening Absolute CTE');
            grid;
            grid minor;

            % rCTE vs wCTE - Normalised
            subplot(2,2,4);
            hold on
            xRef = [0, 1];
            yRef = [0, 1];
            plot(xRef, yRef, 'LineStyle','--', 'Color','black')

            for i = 1:nLaps

                scatter(obj.data(i).metricsCTE.rCTE / obj.data(i).metricsCTE.TACTE, obj.data(i).metricsCTE.wCTE / obj.data(i).metricsCTE.TACTE, 'filled');

            end

            xlabel('Improving Absolute CTE - Normalised');
            ylabel('Worsening Absolute CTE - Normalised');
            grid;
            grid minor;

        end

        %% Function for plotting CTE Metrics
        function plotBarMetricsCTE(obj)

            figure("Name", 'CTE Metrics Bar Plot');
            
            nLaps = size(obj.data, 2);

            barPlotData = [obj.data(1).metricsCTE.rCTE, obj.data(1).metricsCTE.wCTE, obj.data(1).metricsCTE.hCTE];

            for i = 1:nLaps

                barPlotData(i,:) = [obj.data(i).metricsCTE.rCTE, obj.data(i).metricsCTE.wCTE, obj.data(i).metricsCTE.hCTE];

            end

            barPlot = bar(barPlotData, 'stacked');

            barPlot(1).FaceColor = [0 1 0];
            barPlot(2).FaceColor = [1 0 0];
            barPlot(3).FaceColor = [0 0 1];

            xticklabels(obj.plottingTools.legendCell);

            legend({'Improving', 'Worsening', 'Held'})

        
        end
    end
end