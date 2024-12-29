function fnPCA(normalisedData)

    % Exclude the last column (output)
    inputFeatures = table2array(normalisedData);
    inputFeatures = inputFeatures(:, 1:end-1);

    % Get the covariance matrix of the input features
    covMatrix = cov(inputFeatures);

    % Get the correlation matrix of the input features
    corrMatrix = corr(inputFeatures);

    % Perform PCA
    [coeff, score, latent, tsquared, explained, mu] = pca(inputFeatures);

end