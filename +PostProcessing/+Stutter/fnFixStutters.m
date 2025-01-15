%% Function to fix the stutters in the data
function fixedData = fnFixStutters(data, stutterIdx, freq)

    % Only keep the data that doesn't stutter
    fixedData = data(~stutterIdx, :);

    % Get the time step from the freq
    dt = 1/freq;

    % Get the size of the data without stutters
    nEntries = size(fixedData, 1);

    % % Create a new timestep
    % t = dt .* (1:nEntries)';
    % 
    % fixedData.time = t;

    t = zeros([nEntries, 1]);
    for i = 2:nEntries

        u = fixedData.speed(i-1);
        v = fixedData.speed(i);
        s = sqrt((fixedData.posX(i) - fixedData.posX(i-1))^2 + (fixedData.posY(i) - fixedData.posY(i-1))^2);
        t_i = (2 * s) / (u + v);
        t(i) = t_i;

    end

    % Create a new timestep to interpolate over
    t = t(2:end);
    tNew = [0; cumsum(t)];
    tInterp = tNew + fixedData.time(1);
    tQuery = (0:dt:tNew(end))' + fixedData.time(1);
    y = fixedData(:,2:end);
    y = table2array(y);
    fixedData = interp1(tInterp, y, tQuery);





end