%% Function to fix the stutters in the data
function fixedData = fnFixStutters(data, stutterIdx, freq)

    % Only keep the data that doesn't stutter
    fixedData = data(~stutterIdx, :);

    % Get the time step from the freq
    dt = 1/freq;

    % Get the size of the data without stutters
    nEntries = size(fixedData, 1);

    % Create a new timestep
    t = dt .* (1:nEntries)';

    fixedData.time = t;





end