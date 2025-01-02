%% Function to loop an array index
function loopedIdx = fnLoopArrayIndex(A, idx, idxOffset)

    % Get the size of the array
    n = size(A, 1);

    %% Index Looping
    % If idx + idxOffset > n, then you need to loop from the start of the
    % array. E.g. if n is 100, idx is 90 and idxOffset is 25, then the
    % looped index will be 15 = (25 - (100 - 90))
    if idx + idxOffset > n

        loopedIdx = idxOffset - (n - idx);

    % If idx + idxOffset < 0 (in the case of a negative offset), then you
    % need to loop from the end of the array. E.g. if n is 100, idx is 14,
    % and idxOffset is -32, then the looped index will be 82 = (idx + n -
    % idxOffset)
    elseif idx + idxOffset < 0

        loopedIdx = idx + n - abs(idxOffset);

    % In the simplest case, idx + idxOffset is well within the array bounds
    % so you can apply the offset easily
    else

        loopedIdx = idx + idxOffset;

    end



end