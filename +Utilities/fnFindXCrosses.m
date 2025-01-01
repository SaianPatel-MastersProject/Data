%% Function to count the number of crosses through the x-axis
function xCrosses = fnFindXCrosses(y)

    % Find zero-crossings
    zeroCrossings = find(diff(sign(y)) ~= 0);

    % Count the crossings
    xCrosses = length(zeroCrossings);


end