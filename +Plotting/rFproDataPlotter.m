classdef rFproDataPlotter
    
    properties
        
        dataFilePath; % Path to the data csv
        dataTable; % The csv stored as a table
        channels; % List of logged channels
        sampleFrequency; % Sampling rate
        
    end
    
    methods
        
        function obj = rFproDataPlotter(dataFilePath)

            obj.dataFilePath = dataFilePath;
            opts = detectImportOptions(dataFilePath,'NumHeaderLines',0);
            obj.dataTable = readtable(dataFilePath, opts);
            timeStep = diff(obj.dataTable.time);
            obj.sampleFrequency = 1/(timeStep(1));
            
            
        end
        
        function obj = getChannels(obj)
            
            obj.channels = (obj.dataTable.Properties.VariableNames)';
            
            
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

