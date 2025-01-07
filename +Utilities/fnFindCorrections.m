%% Function to count the number of corrections
function nCorrections = fnFindCorrections(y)

    % Find corrections by counting crossings of the x-axis of the
    % derivative
    [nCorrections, ~] = Utilities.fnFindXCrosses(diff(y));



end