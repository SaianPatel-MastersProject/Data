%% Plot the explained variance ratio
figure;
pareto(pcaData.explained);
xlabel('Principal Components');
ylabel('Variance Explained (%)');
title('PCA - Variance Explained by Each Component');

%% Understand feature contributions to PCs

nVars = size(normData, 2) - 1;
nPC = numel(pcaData.explained);


colNames = {'PC', normData.Properties.VariableNames{1:end-1}, 'Explained'};

% Each Row is a PC, Each col is a feature
featureContributionsTable = array2table([(1:nPC)', abs(pcaData.coeff), pcaData.explained], 'VariableNames', colNames);

%% Create bar plot
figure;
bar(table2array(featureContributionsTable(:, 2:end-1)), 'stacked');

% Customize plot
xlabel('Rows in Table (Each Bar)');
ylabel('Value');
title('Stacked Bar Plot from Table Rows');
legend(normData.Properties.VariableNames, 'Location', 'Best');


%% Multiply coeff by explained and sum
total_contribution = zeros([nVars, 1]);

for i = 1:nVars

    total_contribution_i = zeros([1, nVars]);

    for j = 1:3

        total_contribution_i(1,j) = (pcaData.coeff(i,j))^2 * (pcaData.explained(j)/100);

    end

    total_contribution(i,1) = sum(total_contribution_i);


end

%% PFA

feature_importance = sum(abs(pcaData.coeff(:, 1:3)), 2);