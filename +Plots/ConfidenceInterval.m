%% Confidence Interval

% Get number of items in sample
n = numel(objH.runData.metricsCTE.TACTE);

% Get sample mean and variance
sampleMean = mean(objH.runData.metricsCTE.TACTE);
sampleStd = std(objH.runData.metricsCTE.TACTE);
SE = sampleStd/n;
tScore = tinv([0.025, 0.975], n-1);

CI = sampleMean + tScore * SE;