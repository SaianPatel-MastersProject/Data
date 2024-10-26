%% run rFpro csv to mat
function runFileConversion(csvFilePath, runDescription, runNumber, driverName, vehicleModel)

    % Initiate class
    try
    
        obj = PostProcessing.rFproCSVtoMAT(csvFilePath);

    catch ME

        disp('ERROR: Failed to initialise class.')
        disp(ME.message);
        return;

    end
    
    % Get run information
    try

        obj = obj.getRunInfo();
    
    catch ME

        disp('ERROR: Failed to get run information.')
        disp(ME.message);
        return;

    end
    
    % Set the run description
    try

        obj = obj.setRunDescription(runDescription);
    
        catch ME

        disp('ERROR: Failed to set the run description.')
        disp(ME.message);
        return;

    end
    
    % Set the run number
    try
    
        obj = obj.setRunNumber(runNumber);

    catch ME

        disp('ERROR: Failed to set the run number.')
        disp(ME.message);
        return;

    end
    
    % Set the unique iD
    try

        obj = obj.setUniqueIdentifier();

    catch ME

        disp('ERROR: Failed to set the unique ID.')
        disp(ME.message);
        return;

    end
    
    % Set the driver name
    try

        obj = obj.setDriverName(driverName);

    catch ME

        disp('ERROR: Failed to set the driver name.')
        disp(ME.message);
        return;

    end

    % Set the vehicle model description
    try

        obj = obj.setVehicleModel(vehicleModel);

    catch ME

        disp('ERROR: Failed to set the vehicle model description.')
        disp(ME.message);
        return;

    end
    % Get the information on the data
    try

        obj = obj.getDataInfo();

    catch ME

        disp('ERROR: Failed to get information on the data.')
        disp(ME.message);
        return;

    end
    
    % Get the information on the laps
    try

        obj = obj.getLapInfo();

    catch ME

        disp('ERROR: Failed to get information on the laps.')
        disp(ME.message);
        return;

    end
    
    % Save the .mat
    try

        obj.saveData();

    catch ME

        disp('ERROR: Failed to save the data.')
        disp(ME.message);
        return;

    end
    
end