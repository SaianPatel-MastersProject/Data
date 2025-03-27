%% Function to calculate smoothness metric of a given channel for an entire lap
function MChannel = calculateSmoothnessMetricPerCorner(data, channel, track)

    % First check if the specified channel exists in the data
    if ~contains(data.Properties.VariableNames, channel)

        % Throw warning
        warning('The specified channel is not present in the data.')

        % Return if it doesn't
        return;

    end

    % Check if there are multiple laps in the data
    lapsInData = unique(data.lapNumber);
    
    % Get the number of laps in the data
    nLaps = numel(lapsInData);

    % Display to user
    fprintf('There are %i lap(s) in the data.\n', nLaps)

    % Initilaise MChannel
    MChannel = [];

    % Loop through each lap in the data
    for i = 1:nLaps

        % Get the current lap number
        lapNumber = lapsInData(i);

        % Get the data for this lap
        lapData = data(data.lapNumber == lapNumber, :);

        % Get the tLap channel if it exists
        if contains(lapData.Properties.VariableNames, 'tLap')

            % Just grab the channel
            tLap = lapData.tLap;

        else

            % Otherwise create it
            tLap = lapData.time - lapData.time(1);

        end

        % Get dt (0.01s)
        dt = tLap(2) - tLap(1);

        % Get the column of the channel of interest
        channelData = lapData.(channel);

        % Switch-case for handling the channel
        switch channel

            case 'steerAngle'

                y = channelData .* 225;
                y = [0; diff(y) ./ dt];
                y = movmean(y, 51);
                y = abs(y);

            case 'CTE'

                y = channelData;
                y = [0; diff(y) ./ dt];
                y = abs(y);

            case 'HeadingError'

                y = rad2deg(channelData);
                y = [0; diff(y) ./ dt];
                y = abs(y);

            otherwise

                warning('No pre-configured handling of the specified channel.')
                y = channelData;
                y = [0; diff(y) ./ dt];

        end

        % Get the corner ranges
        cornerRanges = Utilities.fnGetCornerRanges(track, false);

        % Get the number of corners
        nCorners = size(cornerRanges, 1);

        % Loop through every corner and get MChannel
        for j = 1:nCorners

            % Integrate y over tLap per corner
            yC = y(and(lapData.lapDist >= cornerRanges(j,1), lapData.lapDist <= cornerRanges(j,2)));
            tC = tLap(and(lapData.lapDist >= cornerRanges(j,1), lapData.lapDist <= cornerRanges(j,2)));

            % Get the corner duration
            tD = tC(end) - tC(1);

            MChannel(i,j) = trapz(tC, yC) / tD;

        end

        


    end
  
end
    







