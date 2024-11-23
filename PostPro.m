%% PostPro
matFilePath = 'D:\Users\Saian\Workspace\Data\+ProcessedData\2024\FYP11_18\2024_FYP11_18_D6_R04.mat';
bInterpolate = true;
nPoints = 10000;
interpMethod = 'spline';

%% Run CTE
PostProcessing.CTE.postProcessCTE(matFilePath, bInterpolate, nPoints, interpMethod);

%% Run VE
PostProcessing.VE.postProcessVE(matFilePath, bInterpolate, nPoints, interpMethod);