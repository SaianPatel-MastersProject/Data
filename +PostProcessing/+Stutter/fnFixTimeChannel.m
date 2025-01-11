%% Function to correct the time channel using speed and distance
function fixedData2 = fnFixTimeChannel(data)

    % Get the Euclidean distance
    d = sqrt(([0; diff(data.posX)]).^2 + ([0; diff(data.posY)]).^2);

    % Get the speed
    vCar = data.speed;

    % Get the time vector
    t = d ./ vCar;
    t = cumsum(t);

    % Get the new time vector
    tNew = (0:0.01:t(end))';

    % Re-interpolate
    fixedDataArray = interp1(t, table2array(data), tNew);

    % Re-write as table
    columnNames = data.Properties.VariableNames';
    fixedData2 = array2table(fixedDataArray, 'VariableNames', columnNames);

    % Overwrite the time channel
    fixedData2.time = tNew;


end