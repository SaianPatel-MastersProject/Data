classdef rFproDataPlotter
    
    properties
        
        dataFilePath; % Path to the data csv
        fullDataTable; % The entire csv stored as a table
        dataTable; % The lap of choice stored as a table
        sampleFrequency; % Sampling rate
        channels; % List of logged channels
        lapNumbers; % List of lap numbers in csv
        
    end
    
    methods
        
        function obj = rFproDataPlotter(dataFilePath)

            obj.dataFilePath = dataFilePath;
            opts = detectImportOptions(dataFilePath,'NumHeaderLines',0);
            obj.fullDataTable = readtable(dataFilePath, opts);
            timeStep = diff(obj.fullDataTable.time);
            obj.sampleFrequency = 1/(timeStep(1));
            
            
        end
        
        function obj = getChannels(obj)
            
            obj.channels = (obj.fullDataTable.Properties.VariableNames)';
            
            
        end
        
        function obj = getLapNumbers(obj)
            
            obj.lapNumbers = unique(obj.fullDataTable.lapNumber);
            
        end
        
        function obj = filterByLap(obj, lap)
            
            obj.dataTable = obj.fullDataTable(obj.fullDataTable.lapNumber == lap,:);
            
        end
        
        function plotFundamentals(obj)
            
            sLap = obj.dataTable.lapDist; % Set sLap as lap distance
            
            figure; % Create a fundamentals figure
            
            %% Plot Car Speed - Speed
            subplot(4,1,1);
            plot(sLap, obj.dataTable.speed * 3.6);
            xlabel('sLap');
            ylabel('Speed (km/h)');
            
            %% Plot Throttle Application
            subplot(4,1,2);
            plot(sLap, obj.dataTable.throttle);
            xlabel('sLap');
            ylabel('Throttle');
            
            %% Plot Brake Application
            subplot(4,1,3);
            plot(sLap, obj.dataTable.brake);
            xlabel('sLap');
            ylabel('Brake');
            
            %% Plot Steering Angle
            subplot(4,1,4);
            plot(sLap, obj.dataTable.steerAngle);
            xlabel('sLap');
            ylabel('Steering Angle');
            
            %% Link Axes
            linkaxes(findall(gcf,'Type','axes'), 'x');

        end
        
        function plotRacingLine(obj)
             
            figure;
            
            line(obj.dataTable.posX, obj.dataTable.posY);
            
            axis equal; % Aspect ratio 1 for plot
            
        end
        
        function plotCombinedBraking(obj)
            
            figure;
            
            scatter(obj.dataTable.steerAngle, obj.dataTable.brake);
            
        end
        
        function plotCombinedTraction(obj)
            
            figure;
            
            scatter(obj.dataTable.steerAngle, obj.dataTable.throttle);
            
        end
        
    end
end

