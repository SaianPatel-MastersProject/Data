%% Function to get corner ranges
function cornerRanges = fnGetCornerRanges(track, addStraights)

    % Read in the nCorner table
    nCorner_Table = readtable(fullfile('D:\Users\Saian\Workspace\Data\+Plotting\+nCorner', sprintf('%s.xlsx', track)), 'VariableNamingRule','preserve');

    % Extract sLap ranges for corners from table
    sLapRanges = [nCorner_Table.sLapMin, nCorner_Table.sLapMax];

    if addStraights

        % Check if the lap starts on a corner (unlikely)
        if sLapRanges(1,1) ~= 0

            cornerRanges_temp = [0, sLapRanges(1,1); sLapRanges];

        else

            cornerRanges_temp = sLapRanges;


        end

        % Pad the end of the lap
        cornerRanges_temp = [cornerRanges_temp; cornerRanges_temp(end,2), 1e6];

        % Get the number of corners
        nCorners = size(cornerRanges_temp, 1);


        % Now check if there are any gaps between corners (signifies straights)
        dCornerDist = zeros([nCorners,1]);

        for i = 2:nCorners

            dCornerDist(i,1) = cornerRanges_temp(i,1) - cornerRanges_temp(i-1, 2);


        end


        % Create final corner ranges array
        cornerRanges = [];

        % Any unaccounted for straights are found with dCornerDist > 0
        for i = 1:nCorners

            if dCornerDist(i,1) == 0

                % Just add the corner range
                cornerRanges(end + 1, :) = cornerRanges_temp(i, :);

            else

                % Otherwise add a straight
                cornerRanges(end + 1, :) = [cornerRanges_temp(i - 1, 2), cornerRanges_temp(i, 1)];
                cornerRanges(end + 1, :) = cornerRanges_temp(i, :);

            end


        end

    else

        cornerRanges = sLapRanges;

    end
    

end