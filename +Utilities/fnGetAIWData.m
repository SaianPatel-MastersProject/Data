%% Function to get AIW Data
function AIW_Data = fnGetAIWData(trackName, bInterpolated, nPoints, interpMethod)

    switch trackName
        case 'Arrow Speedway'

            AIW_Table = readtable('+PostProcessing\+CTE\Arrow.csv');

        case '2kFlat'

            AIW_Table = readtable('+PostProcessing\+CTE\2kFlat.csv');

        otherwise

            % Track not recognised
            return;

    end

    AIW_Data = [AIW_Table.x, AIW_Table.y];

    if bInterpolated

        dBetweenPoints = (sqrt(diff(AIW_Data(:,1)).^2 + diff(AIW_Data(:,2)).^2));
        rollingDistance = [0; cumsum(dBetweenPoints)];
        dNew = (linspace(0, rollingDistance(end), nPoints))';
        xInterp = interp1(rollingDistance, AIW_Data(:,1), dNew, interpMethod);
        yInterp = interp1(rollingDistance, AIW_Data(:,2), dNew, interpMethod);
        AIW_Data = [xInterp, yInterp];

    end


end