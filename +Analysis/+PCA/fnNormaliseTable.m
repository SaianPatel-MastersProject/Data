function normalisedData = fnNormaliseTable(dataTable)

    % Initialise the normalised table using the input table
    normalisedData = dataTable;

    % Get the number of columns and rows
    nCols = size(dataTable, 2);
    nRows = size(dataTable, 1);

    % Create a summary array for debugging
    summary = zeros([nCols, 2]);

    % Loop through each column
    for i = 1:nCols

        % Get the mean of the column
        colMean = mean(dataTable(:,i));

        % Get the standard devaiation of the column
        colStd = std(dataTable(:,i));

        % Store the mean and std
        summary(i,1) = table2array(colMean);
        summary(i,2) = table2array(colStd);

        % Normalise the column
        normalisedData(:,i) = (normalisedData(:,i) - colMean) ./ colStd;

    end


end