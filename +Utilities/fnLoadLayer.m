%% Function to load layers
function runStruct = fnLoadLayer(runStruct, layer)

    % Form the string for the layer
    layerString = sprintf('_%s.mat', layer);

    % Get the layer filepath
    layerFilePath = strrep(runStruct.metadata.matFilePath, '.mat', layerString);

    if isfile(layerFilePath)

        % Load the layer if it exists
        load(layerFilePath);

    else
        try

            layerFilePath = fullfile('D:\Users\Saian\Workspace\Data', layerFilePath);

            load(layerFilePath);

        catch
            
            % Return with warning
            warning('Could not find the specified layer.')
            return;

        end

    end

    % Switch case for the layer
    switch layer
        case 'PE'

            % Join PE layer to the data for the run
            runStruct.data = addvars(runStruct.data, dataPE.CTE, 'NewVariableNames', 'CTE');
            runStruct.data = addvars(runStruct.data, dataPE.closestWaypointX, 'NewVariableNames', 'closestWaypointX');
            runStruct.data = addvars(runStruct.data, dataPE.closestWaypointY, 'NewVariableNames', 'closestWaypointY');
            runStruct.data = addvars(runStruct.data, dataPE.HeadingError, 'NewVariableNames', 'HeadingError');

        case 'KAP'

            % Join VE layer to the data for the run
            runStruct.data = addvars(runStruct.data, dataKAP.kappa, 'NewVariableNames', 'kappa');
            runStruct.data = addvars(runStruct.data, dataKAP.rCurvature, 'NewVariableNames', 'rCurvature');

        case 'CTE'

            % Join CTE layer to the data for the run
            runStruct.data = addvars(runStruct.data, dataCTE.CTE, 'NewVariableNames', 'CTE');
            runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointX, 'NewVariableNames', 'closestWaypointX');
            runStruct.data = addvars(runStruct.data, dataCTE.closestWaypointY, 'NewVariableNames', 'closestWaypointY');

        case 'VE'

            % Join VE layer to the data for the run
            runStruct.data = addvars(runStruct.data, dataVE.vError, 'NewVariableNames', 'vError');
            runStruct.data = addvars(runStruct.data, dataVE.refVel, 'NewVariableNames', 'refVel');
            runStruct.data = addvars(runStruct.data, dataVE.rCurvature, 'NewVariableNames', 'rCurvature');

        case 'ProMoD'

            % Join ProMoD layer to the data for the run
            runStruct.data = addvars(runStruct.data, dataProMoD.MSteer, 'NewVariableNames', 'MSteer');

        otherwise

            % Error - unrecognised layer type
            warning('Unrecognised layer type.')
            return;

    end


end