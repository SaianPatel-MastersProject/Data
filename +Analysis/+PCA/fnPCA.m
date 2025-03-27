function pcaData = fnPCA(normalisedData)

    % Exclude the last column (output)
    inputFeatures = table2array(normalisedData);
    inputFeatures = inputFeatures(:, 1:end-1);

    % Get the covariance matrix of the input features
    pcaData.covMatrix = cov(inputFeatures);

    % Get the correlation matrix of the input features
    pcaData.corrMatrix = corr(inputFeatures);

    % Perform PCA
    [pcaData.coeff, pcaData.score, pcaData.latent, pcaData.tsquared, pcaData.explained, pcaData.mu] = pca(inputFeatures);

end