%% Function to get lookahead curvature (array)
function lookAheadValues = fnGetLookAheadValues(values, targetIdx, lookAheadOffset, nLookAheadPoints)

    % Initilaise the lookAhead array
    lookAheadValues = zeros([1, nLookAheadPoints]);

    % Loop through each look ahead point
    for i = 1:nLookAheadPoints

        % Loop the index
        lookAheadIdx = Utilities.fnLoopArrayIndex(values, targetIdx, i*lookAheadOffset);

        % Get the corresponding data
        lookAheadValues(i) = values(lookAheadIdx);

    end

end