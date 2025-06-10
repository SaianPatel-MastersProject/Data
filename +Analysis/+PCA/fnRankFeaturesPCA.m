function rankedContribution = fnRankFeaturesPCA(pcaData, nPC)

    nFeatures = size(pcaData.covMatrix, 1);
    contributionPerPC = zeros([nFeatures, nPC]);
    
    for i = 1:nPC

        contributionPerPC(:, i) = abs(pcaData.coeff(:,i)) .* (pcaData.explained(i) / 100);




    end

    totalContribution = sum(contributionPerPC, 2);

    [sortedValues, sortedIndices] = sort(totalContribution, 'descend');

    rankedContribution = [sortedIndices, sortedValues];



end