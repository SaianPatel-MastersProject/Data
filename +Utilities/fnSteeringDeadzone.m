%% Function to calculate steering deadzone boundaries given a table of data
function steeringDeadzoneData = fnSteeringDeadzone(data, maxLapDist)

    % Gate the data by sLap so that the data only contains S/F straight
    % data, rather than considering the entire lap (for convenience).
    straightData = data(data.lapDist < maxLapDist, :);
    
    % Find where CTE begins to decrease - this is signified by the
    % derivative of CTE being close to 0.
    [~, dCTE_peaks_locs] = findpeaks(abs([0; diff(straightData.CTE)]./0.01));

    decreasingCTEdata = straightData(dCTE_peaks_locs, :);

    % Store some important information about the deadzone as a struct
    steeringDeadzoneData.data = decreasingCTEdata;
    steeringDeadzoneData.signedMean = mean(decreasingCTEdata.CTE);
    steeringDeadzoneData.signedStd = std(decreasingCTEdata.CTE);
    steeringDeadzoneData.unsignedMean = mean(abs(decreasingCTEdata.CTE));
    steeringDeadzoneData.unsignedStd = std(abs(decreasingCTEdata.CTE));
    



end