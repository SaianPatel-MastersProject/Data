classdef multiPlotter

    % Class to plot multiple laps

    properties

        data; % Struct array of lap-by-lap data
        runData; % Struct array of runData
        plottingTools; % Info for plotting
        

    end

    methods
        function obj = multiPlotter()

            % Construct class
            obj.data = struct('runID', '', 'lapNumber', [], 'lapData', table, 'track', '', 'driver', '', 'metricsCTE', table, 'metricsHE', table);
            obj.runData = struct('runID', '', 'lapNumbers', [], 'runData', table, 'track', '', 'driver', '', 'metricsCTE', table);
            obj.plottingTools = struct();

        end

        %% Function to add an entire run of data
        function obj = addRun(obj, matFilePath, bFlying, lapsFilter)

            % Read in a run .mat file
            load(matFilePath);

            % if ~contains(matFilePath, '_AvgLap')

            % Load Associated Layers - only if the run is not an
            % average lap run
            runStruct = Utilities.fnLoadLayer(runStruct, 'PE');
            runStruct = Utilities.fnLoadLayer(runStruct, 'KAP');
            runStruct = Utilities.fnLoadLayer(runStruct, 'ProMoD');

            % end
            
            % Check how many laps are in the run
            lapsInRun = unique(runStruct.data.lapNumber);
            nLaps = length(lapsInRun);

            % Apply the laps filter
            if ~isempty(lapsFilter)

                for i = 1:numel(lapsFilter)

                    runData_i = runStruct.data(runStruct.data.lapNumber == lapsFilter(i), :);

                    if i == 1

                        runData = runData_i;

                    else

                        runData = [runData; runData_i];

                    end

                end

                % Get the laps in the run
                lapsInRun = unique(runData.lapNumber);
  
            % If there are more than 2 laps (i.e. at least one flying lap
            % with an out and in lap) then only keep the flying laps
            elseif and(nLaps > 2, bFlying)

                runData = runStruct.data(runStruct.data.lapNumber < lapsInRun(end), :);
                runData = runData(runData.lapNumber > 0, :);
                lapsInRun = lapsInRun(2:end-1);

            else

                runData = runStruct.data;
                warning('Using all laps in the run.')

            end

            % Populate the struct array
            % Check current number of entries in the struct
            nEntries = size(obj.runData, 2);

            if isempty(obj.runData(1).lapNumbers)

                i = 1;

            else

                i = nEntries + 1;

            end

            obj.runData(i).runID = runStruct.metadata.runID;
            obj.runData(i).lapNumbers = lapsInRun;
            obj.runData(i).runData = runData;
            obj.runData(i).track = runStruct.metadata.track;
            obj.runData(i).driver = runStruct.metadata.driver;

            % Add metrics CTE and steering
            for j = 1:numel(lapsInRun)

                if ~contains(matFilePath, '_AvgLap')

                    obj.runData(i).metricsCTE(j,:) = PostProcessing.CTE.calculateCTEMetrics(runStruct, lapsInRun(j));
                    obj.runData(i).metricsSteer(j,:) = PostProcessing.Metrics.calculateSteeringMetrics(runStruct, lapsInRun(j));

                else

                    obj.runData(i).metricsCTE(j,:) = PostProcessing.CTE.calculateCTEMetrics(runStruct);
                    obj.runData(i).metricsSteer(j,:) = PostProcessing.Metrics.calculateSteeringMetrics(runStruct);

                end

            end


        end
        
        %% Function to add a single lap of data
        function obj = addLap(obj, matFilePath, lapNumber)

            % Read in a run .mat file
            load(matFilePath);

            % Get the track
            track = runStruct.metadata.track;

            % Get the runID
            runID = runStruct.metadata.runID;

            % Get the driver
            driver = runStruct.metadata.driver;

            %% Read in layers
            runStruct = Utilities.fnLoadLayer(runStruct, 'PE');
            runStruct = Utilities.fnLoadLayer(runStruct, 'KAP');
            runStruct = Utilities.fnLoadLayer(runStruct, 'ProMoD');

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

            obj.data(i).metricsSteer = PostProcessing.Metrics.calculateSteeringMetrics(runStruct, lapNumber);

            %% Populate the struct
            obj.data(i).runID = runID;
            obj.data(i).lapNumber = lapNumber;
            obj.data(i).lapData = lapData;
            obj.data(i).track = track;
            obj.data(i).driver = driver;

            %% Update Plotting Tools based on the added lap
            obj = obj.updateLegendCell();
            
        end

        %% Function to add an average lap
        function obj = addAverageLap(obj, matFilePath)

            % Set the lapNumber as 1 for AvgLaps
            lapNumber = 1;

            % Read in a run .mat file
            load(matFilePath);

            % Get the track
            track = runStruct.metadata.track;

            % Get the runID
            runID = runStruct.metadata.runID;

            % Get the driver
            driver = runStruct.metadata.driver;

            %% Read in layers
            % runStruct = Utilities.fnLoadLayer(runStruct, 'PE');
            % runStruct = Utilities.fnLoadLayer(runStruct, 'KAP');
            % runStruct = Utilities.fnLoadLayer(runStruct, 'ProMoD');

            %% Fetch the data for the selected lap
            lapData = runStruct.data;

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
            obj.data(i).metricsCTE = PostProcessing.CTE.calculateCTEMetrics(runStruct);

            %% Get the Heading Error metrics sumamry
            obj.data(i).metricsHE = PostProcessing.PE.calculateHeadingErrorMetrics(runStruct);

            obj.data(i).metricsSteer = PostProcessing.Metrics.calculateSteeringMetrics(runStruct);

            %% Populate the struct
            obj.data(i).runID = runID;
            obj.data(i).lapNumber = lapNumber;
            obj.data(i).lapData = lapData;
            obj.data(i).track = track;
            obj.data(i).driver = driver;

            %% Update Plotting Tools based on the added lap
            obj = obj.updateLegendCell();
            
        end

        %% Function to update the legend cell
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

        %% Function to add reference colours for the laps
        function obj = addLapsColours(obj, lapsColours)

            % Should be passed in as a cell array of hex codes

            % Only keep if it matches the number of laps
            if length(lapsColours) ~= size(obj.data,2)

                error('The number of colours provided does not match the number of laps')

            end

            % Save laps Colours
            obj.plottingTools.lapsColours = lapsColours;


        end
        
        %% Function to plot fundamentals
        function plotFundamentals(obj)
            
            figure("Name", 'Fundamentals'); % Create a fundamentals figure
            
            nLaps = size(obj.data, 2);

            %% Plot Car Speed - Speed
            subplot(4,1,1);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.speed * 3.6);

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

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.throttle);

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

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.brake);

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

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.steerAngle);

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

             subplot(2,1,1);
             hold on

             for i = 1:nLaps

                 plot(obj.data(i).lapData.tLap, obj.data(i).lapData.steerAngle * steeringScalar);

             end

             xlabel('Lap Time (s)');
             ylabel('Steering Angle (°)');
             legend(obj.plottingTools.legendCell);
             grid;
             grid minor;

             subplot(2,1,2);
             hold on

             for i = 1:nLaps

                 % Get dt
                 dt = obj.data(i).lapData.tLap(2) - obj.data(i).lapData.tLap(1);
                 dSteerAngle = [0; diff(obj.data(i).lapData.steerAngle .* steeringScalar)./ dt];
                 plot(obj.data(i).lapData.tLap, dSteerAngle);

             end

             xlabel('Lap Time (s)');
             ylabel('Steering Velocity (°/s)');
             grid;
             grid minor;

             % subplot(3,1,3);
             % hold on
             % 
             % for i = 1:nLaps
             % 
             %     % Get dt
             %     dt = obj.data(i).lapData.tLap(2) - obj.data(i).lapData.tLap(1);
             %     dSteerAngle = [0; diff(obj.data(i).lapData.steerAngle .* steeringScalar)./ dt];
             %     ddSteerAngle = [0; diff(dSteerAngle)./ dt];
             % 
             %     plot(obj.data(i).lapData.tLap, ddSteerAngle);
             % 
             % end
             % 
             % xlabel('Lap Time (s)');
             % ylabel('Second Derivative of Steer Angle');
             % grid;
             % grid minor;

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

                        AIW_Table = readtable('+PostProcessing\+CTE\2kF_SUZE9.csv');
                        % % Track not recognised
                        % return;

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

        %% Function for plotting steering
        function plotSteering(obj)

            nLaps = size(obj.data, 2);

            figure("Name", 'Steering Trace');

            subplot(2,1,1)
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.steerAngle .* 225);

            end

            xlabel('Lap Distance (m)');
            ylabel('Steering Angle (deg)');
            title('Steering Trace')
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;

            subplot(2,1,2)
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, obj.data(i).lapData.steerAngle .* 225);

            end

            xlabel('Lap Time (s)');
            ylabel('Steering Angle (deg)');
            grid;
            grid minor;

        end
        
        %% Function for plotting errors with steering
        function plotErrorsWithSteering(obj)

            figure("Name", 'Fundamentals'); % Create a fundamentals figure
            
            nLaps = size(obj.data, 2);

            % Plot Steering
            subplot(3,1,1);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, obj.data(i).lapData.steerAngle * 225);

            end
            
            xlabel('Lap Time (s)');
            ylabel('Steering Angle (deg)');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            
            % Plot CTE
            subplot(3,1,2);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, obj.data(i).lapData.CTE);

            end

            xlabel('Lap Time (s)');
            ylabel('CTE (m)');
            grid;
            grid minor;
            
            % Plot Heading Error
            subplot(3,1,3);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, rad2deg(obj.data(i).lapData.HeadingError));

            end

            xlabel('Lap Time (s)');
            ylabel('Heading Error (deg)');
            grid;
            grid minor;

            %% Link Axes
             linkaxes(findall(gcf,'Type','axes'), 'x');

        end

        %% Function for plotting CTE
        function plotCurvature(obj)

            nLaps = size(obj.data, 2);
           
            figure;

            subplot(2,1,1);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.kappa);

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

        %% Function for plotting how TACTE varies over time
        function plotRollingTACTE(obj)

            figure("Name", 'TACTE Over Time'); % Create a fundamentals figure
            
            nLaps = size(obj.data, 2);

            % Plot Steering
            subplot(2,1,1);
            hold on

            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, obj.data(i).lapData.steerAngle * 225);

            end
            
            xlabel('Lap Time (s)');
            ylabel('Steering Angle (deg)');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            
            % Plot CTE
            subplot(2,1,2);
            hold on

            for i = 1:nLaps

                rollingTACTE = zeros([ size(obj.data(i).lapData, 1) , 1]);

                for j = 2:size(obj.data(i).lapData, 1)

                    rollingTACTE(j) = trapz(obj.data(i).lapData.tLap(1:j), abs(obj.data(i).lapData.CTE(1:j)));

                end

                plot(obj.data(i).lapData.tLap, rollingTACTE);

            end
            
            xlabel('Lap Time (s)');
            ylabel('Rolling TACTE (m)');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            

            %% Link Axes
             linkaxes(findall(gcf,'Type','axes'), 'x');

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
                dCTE = [0; (diff((obj.data(i).lapData.CTE)))./ dt];
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
                dCTE = [0; (diff((obj.data(i).lapData.CTE)))./ dt];
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
            
            for i = 1:nLaps

                scatter(obj.data(i).metricsCTE.rCTE, obj.data(i).metricsCTE.wCTE, 'filled');

            end

            plot(xRef, yRef, 'LineStyle','--', 'Color','black')


            xlabel('Improving Absolute CTE - Normalised');
            ylabel('Worsening Absolute CTE - Normalised');
            grid;
            grid minor;

        end

        %% Function for plotting CTE Metrics
        function plotBarMetricsCTE(obj, mode)

            figure("Name", 'CTE Metrics Bar Plot');
            
            nLaps = size(obj.data, 2);

            switch mode
                case 'Percentage'

                    barPlotData = [obj.data(1).metricsCTE.rCTE_pct, obj.data(1).metricsCTE.wCTE_pct, obj.data(1).metricsCTE.hCTE_pct];

                    for i = 1:nLaps

                        barPlotData(i,:) = [obj.data(i).metricsCTE.rCTE_pct, obj.data(i).metricsCTE.wCTE_pct, obj.data(i).metricsCTE.hCTE_pct];

                    end

                case 'Normalised'

                    barPlotData = [obj.data(1).metricsCTE.rCTE, obj.data(1).metricsCTE.wCTE, obj.data(1).metricsCTE.hCTE];

                    for i = 1:nLaps

                        barPlotData(i,:) = [obj.data(i).metricsCTE.rCTE, obj.data(i).metricsCTE.wCTE, obj.data(i).metricsCTE.hCTE];

                    end

            end
           

            barPlot = bar(barPlotData, 'stacked');

            barPlot(1).FaceColor = [0 1 0];
            barPlot(2).FaceColor = [1 0 0];
            barPlot(3).FaceColor = [0 0 1];

            xticklabels(obj.plottingTools.legendCell);

            legend({'Improving', 'Worsening', 'Held'})

        
        end
    
        %% Function for plotting smoothness Metrics
        function plotSmoothnessMetrics(obj)

            nLaps = size(obj.data, 2);
           
            figure("Name", 'Smoothness Metrics');

            hold on

            for i = 1:nLaps

                % Calculate Smoothness of Steering
                MSteer = PostProcessing.ProMoD.calculateSmoothnessMetric(obj.data(i).lapData, 'steerAngle');

                % Calculate Smoothness of CTE
                MCTE = PostProcessing.ProMoD.calculateSmoothnessMetric(obj.data(i).lapData, 'CTE');

                scatter(MCTE, MSteer, 'filled');

            end

            xlabel('M_c');
            ylabel('M_s');
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;
            
          

        end

        %% Function to plot 'Reaction Time'
        function rTimeStruct = plotCorrectionTime(obj)

            nLaps = size(obj.data, 2);

            % Create a struct of reaction times and corresponding indices
            rTimeStruct = struct('xCTE', [], 'xSteer', [], 'rT', []);

            for i = 1:nLaps

                % Find where the CTE switches from improving to worsening
                dACTE = diff(abs(obj.data(i).lapData.CTE)) ./ 0.01;
                dACTE = dACTE(dACTE > 0.1 | dACTE < -0.1);
                [~, xCrossesCTE] = Utilities.fnFindXCrosses(dACTE);

                % Find where the steering is corrected
                [~, xCrossesSteer] = Utilities.fnFindXCrosses(diff(obj.data(i).lapData.steerAngle));

                nextIdx = [];
                tReact = [];

                for j = 1:numel(xCrossesCTE)

                    idxDiff = xCrossesSteer - xCrossesCTE(j);

                    idxDiff = idxDiff(idxDiff > 0);

                    [jj, ~] = min(idxDiff);

                    try

                        nextIdx(j,1) = jj + xCrossesCTE(j);
    
                        tReact(j,1) = jj * 0.01;
                    catch ME

                        nextIdx(j,1) = NaN;
    
                        tReact(j,1) = NaN;


                    end

                end

                rTimeStruct(i).xCTE = xCrossesCTE;
                rTimeStruct(i).xSteer = unique(nextIdx);
                rTimeStruct(i).rT = tReact;

            end
           
            figure("Name", 'Correction Time');
            
            % Steering Angle
            subplot(2,1,1)
            hold on
            
            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, obj.data(i).lapData.steerAngle)
            
            end

            xlabel('Lap Time (s)');
            ylabel('Steering Angle (deg)');
            grid;
            grid minor;

            for i = 1:nLaps

                 % Overlay Corrections
                scatter(obj.data(i).lapData.tLap(rTimeStruct(i).xCTE), obj.data(i).lapData.steerAngle(rTimeStruct(i).xCTE), 'filled', 'MarkerFaceColor','red', 'SizeData', 16);
                scatter(obj.data(i).lapData.tLap(rTimeStruct(i).xSteer), obj.data(i).lapData.steerAngle(rTimeStruct(i).xSteer), 'filled', 'MarkerFaceColor','green', 'SizeData', 16);

            end

            % CTE
            subplot(2,1,2)
            hold on
            
            for i = 1:nLaps

                plot(obj.data(i).lapData.tLap, obj.data(i).lapData.CTE)
            
            end

            xlabel('Lap Time (s)');
            ylabel('CTE (m)');
            grid;
            grid minor;

            for i = 1:nLaps

                 % Overlay Corrections
                scatter(obj.data(i).lapData.tLap(rTimeStruct(i).xCTE), obj.data(i).lapData.CTE(rTimeStruct(i).xCTE), 'filled', 'MarkerFaceColor','red', 'SizeData', 16);
                scatter(obj.data(i).lapData.tLap(rTimeStruct(i).xSteer), obj.data(i).lapData.CTE(rTimeStruct(i).xSteer), 'filled', 'MarkerFaceColor','green', 'SizeData', 16);

            end

            %% Link Axes
            linkaxes(findall(gcf,'Type','axes'), 'x');

            %% Plot a boxplot
            figure("Name", 'Correction Time Box Plot');

            % Flatten for the boxplot
            x = [];
            g = {};
            for i = 1:nLaps

                g_i = {};
                x_i = rTimeStruct(i).rT;
                n_i = numel(x_i);
                for j = 1:n_i
                    g_i{j, 1} = sprintf('%i', i);
                end

                if i == 1

                    x = x_i;
                    g = g_i;

                else

                    x = [x; x_i];
                    g = vertcat(g, g_i);

                end

            end

            boxplot(x, g)
            xticklabels(obj.plottingTools.legendCell);
            xlabel('Lap')
            ylabel('Correction Time (s)')
            title('Correction Time Box Plot')
            

        end

        %% Function to plot CTE box plot
        function plotBoxCTE(obj)

            nLaps = size(obj.data, 2);

            % Plot a boxplot
            figure("Name", 'CTE Box Plot');

            % Flatten for the boxplot
            x = [];
            g = {};
            for i = 1:nLaps

                g_i = {};
                x_i = obj.data(i).lapData.CTE;
                n_i = numel(x_i);
                for j = 1:n_i
                    g_i{j, 1} = sprintf('%i', i);
                end

                if i == 1

                    x = x_i;
                    g = g_i;

                else

                    x = [x; x_i];
                    g = vertcat(g, g_i);

                end

            end

            boxplot(x, g)
            xticklabels(obj.plottingTools.legendCell);
            xlabel('Lap')
            ylabel('CTE (m)')
            title('CTE Box Plot')

        end

        %% Function to plot Steering box plot
        function plotBoxSteering(obj)

            nLaps = size(obj.data, 2);

            % Plot a boxplot
            figure("Name", 'Steering Box Plot');

            % Flatten for the boxplot
            x = [];
            g = {};
            for i = 1:nLaps

                g_i = {};
                x_i = obj.data(i).lapData.steerAngle * 225;
                n_i = numel(x_i);
                for j = 1:n_i
                    g_i{j, 1} = sprintf('%i', i);
                end

                if i == 1

                    x = x_i;
                    g = g_i;

                else

                    x = [x; x_i];
                    g = vertcat(g, g_i);

                end

            end

            boxplot(x, g)
            xticklabels(obj.plottingTools.legendCell);
            xlabel('Lap')
            ylabel('Steering Angle (deg)')
            title('Steering Box Plot')

        end
    
    
        %% Function to show envelopes
        function plotEnvelope(obj, runIdx, channel, bOverlayLaps)

            nLaps = size(obj.runData(runIdx).lapNumbers,1);

            % Get the largest start distance and smallest end distance for the set of laps
            lapStart = -1;
            lapEnd = 1e6;

            for i = 1:nLaps

                lap_i = obj.runData(runIdx).lapNumbers(i);

                lapData = obj.runData(runIdx).runData(obj.runData(runIdx).runData.lapNumber == lap_i, :);

                lapStart_i = min(lapData.lapDist);

                lapEnd_i = max(lapData.lapDist);

                % Update as necessary
                if lapStart_i > lapStart

                    lapStart = lapStart_i;

                end

                if lapEnd_i < lapEnd

                    lapEnd = lapEnd_i;

                end

            end

            % Re-interpolate to a common sLap vector
            nPoints = 2000;
            sLap = linspace(lapStart, lapEnd, nPoints)';

            % Create a new array of channel data for each lap
            channelArray = zeros([nPoints, nLaps]);

            for i = 1:nLaps

                % Interpolate the lap data and store it
                lap_i = obj.runData(runIdx).lapNumbers(i);

                lapData = obj.runData(runIdx).runData(obj.runData(runIdx).runData.lapNumber == lap_i, :);

                % Find where lapDist stutters
                dLapDist = [1; diff(lapData.lapDist)];
                stutterIdx = dLapDist ~= 0;
                lapData = lapData(stutterIdx, :);

                % 
                channelArray(:,i) = interp1(lapData.lapDist, lapData.(channel), sLap);

            end

            %  Get the row-wise stats metrics
            % (mean, stdev, max, min)
            meanValues = mean(channelArray, 2);
            stdValues = std(channelArray, 1, 2);
            maxValues = max(channelArray, [], 2);
            minValues = min(channelArray, [], 2);

            % Plot
            % Plot the average lap with envelope
            figure;
            hold on;
            
            % Plot min-max envelope
            patch([sLap; flip(sLap)], [meanValues + stdValues; flip(meanValues - stdValues)], 'k', 'FaceAlpha', 0.4)

            % Plot mean ± standard deviation envelope
            patch([sLap; flip(sLap)], [minValues; flip(maxValues)], 'k', 'FaceAlpha', 0.2)

            % Plot mean values
            plot(sLap, meanValues, 'k--', 'LineWidth', 2, 'DisplayName', 'Average');

            % Get the number of specified laps
            nLaps = size(obj.data, 2);

            if and(bOverlayLaps, nLaps > 0)

                % Plot each lap
                for i = 1:nLaps

                    plot(obj.data(i).lapData.lapDist, obj.data(i).lapData.(channel),  'LineWidth', 2);

                end

            end

            % Customize plot
            title('Average Lap with Variability Envelope');
            xlabel('Lap Distance (m)');
            ylabel(channel);
            legend('Mean ± Std Dev', 'Min-Max', 'Average', 'Human', 'FFNN', 'Location', 'Best');
            grid on;
            hold off;

        end

        %% Function to plot pspectrum
        function plotPSpectrum(obj, channel, mode)

            figure;
            hold on

            switch mode
                case 'Lap'
                    nLaps = size(obj.data, 2);
                    for i = 1:nLaps
        
                        pspectrum(obj.data(i).lapData.(channel), 100);
        
                    end
                case 'Run'

                    nRuns = size(obj.runData, 2);
                    for i = 1:nRuns
        
                        pspectrum(obj.runData(i).runData.(channel), 100);
        
                    end
            end

            title(sprintf('PSpectrum: %s', channel))
            legend(obj.plottingTools.legendCell);
            grid;
            grid minor;

        end

        %% Function to plot violins for a run
        function plotRunViolins(obj)

            figure("Name", 'Run Violins');

            nRuns = size(obj.runData, 2);

            % Steering Angle 
            subplot(2,2,1);
            hold on
            for i = 1:nRuns

                violinplot(obj.runData(i).runData.steerAngle * 225);

            end
            ylabel('Steering Angle')
            legend(obj.plottingTools.legendCell)

             % dSteering Angle 
            subplot(2,2,2);
            hold on
            for i = 1:nRuns

                violinplot([0; diff(obj.runData(i).runData.steerAngle * 225) * 100]);

            end
            ylabel('dSteerAngle')

            nRuns = size(obj.runData, 2);

            % CTE
            subplot(2,2,3);
            hold on
            for i = 1:nRuns

                violinplot(obj.runData(i).runData.CTE);

            end
            ylabel('CTE')

            % dCTE
            subplot(2,2,4);
            hold on
            for i = 1:nRuns

                violinplot([0; diff(obj.runData(i).runData.CTE)]);

            end
            ylabel('dCTE')
        end

        %% Function to plot lap metrics, grouped by run
        function plotGroupedMetrics(obj)

            figure("Name", 'Grouped Metrics');

            nRuns = size(obj.runData, 2);

            % TCTE
            subplot(2,2,1);
            hold on
            for i = 1:nRuns

                violinplot(obj.runData(i).metricsCTE.TCTE);

            end
            ylabel('TCTE')
            legend(obj.plottingTools.legendCell)

            % TACTE
            subplot(2,2,2);
            hold on
            for i = 1:nRuns

                violinplot(obj.runData(i).metricsCTE.TACTE);

            end
            ylabel('TACTE')

            nRuns = size(obj.runData, 2);

            % rRW
            subplot(2,2,3);
            hold on
            for i = 1:nRuns

                violinplot(obj.runData(i).metricsCTE.rRW);

            end
            ylabel('rRW')

            % Average CTE
            subplot(2,2,4);
            hold on
            for i = 1:nRuns

                violinplot(obj.runData(i).metricsCTE.CTE_avg);

            end
            ylabel('Average CTE')


        end

        %% Function to plot transfer function
        function plotTF(obj, inputChannel, outputChannel, mode, bNormalise)

            figure("Name", 'Transfer Function');
            hold on
            title('Transfer Function')

            switch mode
                case 'Lap'
                    nLaps = size(obj.data, 2);
                    for i = 1:nLaps
        
                        x = obj.data(i).lapData.(inputChannel);
                        y = obj.data(i).lapData.(outputChannel);

                        if bNormalise

                            x = 2 * (x - min(x))/(max(x) - min(x)) - 1;
                            y = 2 * (y - min(y))/(max(y) - min(y)) - 1;

                        end

                        nSamples = length(x);
                        fftLength = ceil(nSamples/16);
                        windowVector = hanning(fftLength)*2;
                        nOverlap = ceil(7*fftLength/8);
                        [txy,tf] = tfestimate(x,y,windowVector,nOverlap,fftLength, 100);
                        % txy = txy .* ((1j .* 2 .* pi .* tf) .^ 1); % If wanting to look at derivatives
                        [coh, freq] = mscohere(x,y,windowVector,nOverlap,fftLength, 100);

                        subplot(3,1,1)
                        hold on
                        plot(tf, abs(txy))
                        
                        subplot(3,1,2)
                        hold on
                        plot(tf, angle(txy))

                        subplot(3,1,3)
                        hold on
                        plot(freq, coh)



                    end

                case 'Run'

                    nRuns = size(obj.runData, 2);
                    for i = 1:nRuns
        
                        x = obj.runData(i).runData.(inputChannel);
                        y = obj.runData(i).runData.(outputChannel) .* 225;

                        if bNormalise

                            x = 2 * (x - min(x))/(max(x) - min(x)) - 1;
                            y = 2 * (y - min(y))/(max(y) - min(y)) - 1;

                        end

                        nSamples = length(x);
                        fftLength = ceil(nSamples/512);
                        windowVector = hanning(fftLength)*2;
                        nOverlap = ceil(7*fftLength/8);
                        [txy,tf] = tfestimate(x,y,windowVector,nOverlap,fftLength, 100);
                        % txy = txy .* ((1j .* 2 .* pi .* tf) .^ 1); % If wanting to look at derivatives
                        [coh, freq] = mscohere(x,y,windowVector,nOverlap,fftLength, 100);

                        subplot(3,1,1)
                        hold on
                        plot(tf, abs(txy))

                        subplot(3,1,2)
                        hold on
                        plot(tf, angle(txy))

                        subplot(3,1,3)
                        hold on
                        plot(freq, coh)

                    end

            end

            subplot(3,1,1)
            xlabel('Frequency (Hz)')
            ylabel('Magnitude')
            grid;
            grid minor;

            subplot(3,1,2)
            xlabel('Frequency (Hz)')
            ylabel('Phase Angle')
            grid;
            grid minor;

            subplot(3,1,3)
            hold on
            xlabel('Frequency (Hz)')
            ylabel('Coherence')
            grid;
            grid minor;

            % Link Axes
            linkaxes(findall(gcf,'Type','axes'), 'x');


        end
        
        %% Function to plot line distribution for a run
        function plotLineDistribution(obj, runIdx, plotAIW, lapsIdx)

            figure("Name", 'Line Distribution')
            hold on

            nLapsInRun = size(obj.runData(runIdx).lapNumbers,1);

            for i = 1:nLapsInRun

                lap_i = obj.runData(runIdx).lapNumbers(i);

                lapData = obj.runData(runIdx).runData(obj.runData(runIdx).runData.lapNumber == lap_i, :);

                % plot(lapData.posX, lapData.posY, 'Color', 'k', 'LineWidth', 6)
                set(gcf, 'Renderer', 'opengl')
                lineDist = line(lapData.posX, lapData.posY, 'LineWidth', 4);
                lineDist.Color = [0, 0, 0, 0.1];

            end

            % Plot the reference AIW if specified
            if plotAIW

                switch obj.runData(runIdx).track
                    case 'Arrow Speedway'

                        AIW_Table = readtable('+PostProcessing\+CTE\Arrow.csv');

                    case '2kFlat'

                        AIW_Table = readtable('+PostProcessing\+CTE\2kFlat.csv');

                    otherwise

                        AIW_Table = Utilities.fnLoadAIW(obj.runData(runIdx).track);
                        % AIW_Table = readtable('+PostProcessing\+CTE\2kF_SUZE9.csv');
                        % % Track not recognised
                        % return;

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

                % Grey - '#F2F2F2'
                % Green - '#189900'
                plot(AIW_Data(:,1), AIW_Data(:,2), 'LineStyle','--', 'Color', '#189900', 'LineWidth', 2);

                grid on;
                grid minor;

            end

            % Overlay laps if specified
            if ~isempty(lapsIdx)

                for i = 1:numel(lapsIdx)

                    idx = lapsIdx(i);

                    try

                        plot(obj.data(idx).lapData.posX, obj.data(idx).lapData.posY, 'LineWidth', 3, 'Color', obj.plottingTools.lapsColours{idx});

                    catch

                        plot(obj.data(idx).lapData.posX, obj.data(idx).lapData.posY, 'LineWidth', 3);

                    end

                end

            end

            axis equal
            title('Racing Line Distributions');
            xlabel('x (m)');
            ylabel('y (m)');

        end

        %% Function to plot line distribution for a run - Corner By Corner
        function plotLineDistributionPerCorner(obj, runIdx, plotAIW, lapsIdx)

            figure("Name", 'Line Distribution')
            hold on

            % Read in the nCorner sheet
            nCorner_Table = readtable(fullfile('+Plotting\+nCorner', [obj.runData(runIdx).track, '.xlsx']));

            % Get number of corners
            nCorners = size(nCorner_Table, 1);

            % Get m and n for subplotting
            m = nCorner_Table.m(1);
            n = nCorner_Table.n(1);

            % Get the number of laps in the run
            nLapsInRun = size(obj.runData(runIdx).lapNumbers,1);

            for j = 1:nCorners

                subplot(m, n, j)
                hold on

                for i = 1:nLapsInRun

                    lap_i = obj.runData(runIdx).lapNumbers(i);

                    lapData = obj.runData(runIdx).runData(obj.runData(runIdx).runData.lapNumber == lap_i, :);

                    plot(lapData.posX, lapData.posY, 'Color', 'k', 'LineWidth', 6)

                end

                % Plot the reference AIW if specified
                if plotAIW

                    switch obj.runData(runIdx).track
                        case 'Arrow Speedway'

                            AIW_Table = readtable('+PostProcessing\+CTE\Arrow.csv');

                        case '2kFlat'

                            AIW_Table = readtable('+PostProcessing\+CTE\2kFlat.csv');

                        otherwise

                            AIW_Table = Utilities.fnLoadAIW(obj.runData(runIdx).track);
                            % AIW_Table = readtable('+PostProcessing\+CTE\2kF_SUZE9.csv');
                            % % Track not recognised
                            % return;

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

                    % Grey - '#F2F2F2'
                    % Darker Green - '#189900'
                    plot(AIW_Data(:,1), AIW_Data(:,2), 'LineStyle','--', 'Color', '#F2F2F2', 'LineWidth', 2);

                end

                % Overlay laps if specified
                if ~isempty(lapsIdx)

                    for i = 1:numel(lapsIdx)

                        idx = lapsIdx(i);

                        try

                            plot(obj.data(idx).lapData.posX, obj.data(idx).lapData.posY, 'LineWidth', 3, 'Color', obj.plottingTools.lapsColours{idx});

                        catch

                            plot(obj.data(idx).lapData.posX, obj.data(idx).lapData.posY, 'LineWidth', 3);

                        end

                    end

                end

                % axis equal
                title(sprintf('Turn %i', j));
                xlabel('x (m)');
                ylabel('y (m)');
                xlim([nCorner_Table.xMin(j), nCorner_Table.xMax(j)])
                ylim([nCorner_Table.yMin(j), nCorner_Table.yMax(j)])
                grid on;
                grid minor;
                



            end
            
        end

        %% Statistical Distributions & Tests
        function ksTestResults = fnKSTest(obj, runIdx1, runIdx2)

            % Function to run a two-sample Kolmogorov-Smirnov test -
            % assessing whether the metrics from the two runs are from the
            % same distribution. Produces a struct array for each of the
            % metrics types (CTE, Steer, etc)

            % Set the metrics groups
            metricsGroups = {'metricsCTE', 'metricsSteer'};

            % Initialise a struct array for the results
            ksTestResults = struct('metricsGroup', '', 'testResults', table);

            for i = 1:length(metricsGroups)

                % Set the data groups using the specified indices
                data1 = obj.runData(runIdx1).(metricsGroups{i});
                data2 = obj.runData(runIdx2).(metricsGroups{i});

                % Get the number of metrics - defined by the number of
                % columns in the respective metrics tables
                nMetrics = size(data1, 2);

                % Get the names of the metrics
                metricsNames = (data1.Properties.VariableNames)';

                % Initialise a table to store the test results
                h_i = zeros([nMetrics, 1]);
                p_i = h_i;
                t_i = h_i;
                testResults_i = table(metricsNames, h_i, p_i, t_i, 'VariableNames', {'Metric', 'h', 'p', 't'});

                % Iterate over each metric in the group and run the K-S
                % Test, storing the results in the table
                for j = 1:nMetrics

                    % Run the test
                    [h_j, p_j, t_j] = kstest2(data1.(metricsNames{j}), data2.(metricsNames{j}));

                    % Store the results
                    testResults_i.h(j) = h_j;
                    testResults_i.p(j) = p_j;
                    testResults_i.t(j) = t_j;

                end

                % Store the outcome in the struct array
                ksTestResults(i).metricsGroup = (metricsGroups{i});
                ksTestResults(i).testResults = testResults_i;


            end

        end

        %% Metrics Comparison & Percentage Difference
        function metricsComparison = fnMetricsComparison(obj, refIdx, runIdx)

            % Set the metrics groups
            metricsGroups = {'metricsCTE', 'metricsSteer'};

            % Initialise a struct array
            metricsComparison = struct('metricGroup', '', 'avgMetricsVals', table);

            % Loop through each metric group
            for i = 1:length(metricsGroups)

                % Set the data groups using the specified indices
                refData = obj.runData(refIdx).(metricsGroups{i});

                % Get the number of metrics - defined by the number of
                % columns in the respective metrics tables
                nMetrics = size(refData, 2);

                % Get the names of the metrics
                metricsNames = (refData.Properties.VariableNames)';

                % Get the number of runs compared to the ref
                nRuns = numel(runIdx);

                % Get the total number of runs
                nRunsTotal = 1 + nRuns;

                % Initialise arrays to store values
                avgMetricsVals = zeros([nMetrics, nRunsTotal]);
                pctDiffs = zeros([nMetrics, nRunsTotal]);

                % Loop through each metric
                for j = 1:nMetrics

                    avgMetricsVals(j,1) = mean(refData.(metricsNames{j}));

                    for k = 1:nRuns

                        % Get the average of the metric
                        avgMetricsVals(j, k+1) = mean(obj.runData(runIdx(k)).(metricsGroups{i}).(metricsNames{j}));

                        % Calculate percentage differences
                        pctDiffs(j, k+1) = ((avgMetricsVals(j, k+1) - avgMetricsVals(j,1))/(avgMetricsVals(j,1)))*100;


                    end

                end

            % Store the results as a table
            metricsComparison(i).metricGroup = metricsGroups{i};

            avgMetricsValsTable = table(metricsNames, 'VariableNames', {'Metric'});
            avgMetricsValsTable = addvars(avgMetricsValsTable, avgMetricsVals, 'NewVariableNames', {'Average Metric Values'});
            avgMetricsValsTable = addvars(avgMetricsValsTable, pctDiffs, 'NewVariableNames', {'Percentage Difference'});
            metricsComparison(i).avgMetricsVals = avgMetricsValsTable;




            end




        end
    end
end