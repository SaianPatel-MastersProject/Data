%% Function to count the number of crosses through the x-axis
function [nCrosses, idxCrosses] = fnFindXCrosses(y)

    % Find zero-crossings
    idxCrosses = find(diff(sign(y)) ~= 0);

    % Count the crossings
    nCrosses = length(idxCrosses);


end