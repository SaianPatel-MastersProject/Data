%% Function to check whether inputs are within training range
function [bOutOfRange] = fnCheckInputRange(trainingInputs, dataInputs)

    % Create a logical array for checking that the inputs are within the
    % ranges of the training data
    bOutOfRange = zeros([size(dataInputs, 1), size(dataInputs, 2)]);

    % Loop through the data by column
    for i = 1:size(dataInputs, 2)

        % Get the bounds of the training data
        maxVal = table2array(max(trainingInputs(:,i)));
        minVal = table2array(min(trainingInputs(:,i)));

        % Check out of bounds data
        bOutOfRange(:,1) = or(dataInputs(:,i) < minVal , dataInputs(:,i) > maxVal);

    end

end