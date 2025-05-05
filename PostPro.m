%% PostPro
matFilePath = 'D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_05\2025_FYP05_05_D1_R06.mat';

interpType = 'Distance';
interpParam = 0.1;
interpMethod = 'spline';

% Alternative
% interpType = 'Points';
% interpParam = 10000;
% interpMethod = 'spline';

%% Run PE
PostProcessing.PE.postProcessPE(matFilePath, interpType, interpParam, interpMethod);

%% Run KAP
PostProcessing.KAP.postProcessKAP(matFilePath, interpType, interpParam, interpMethod);

%% Run ProMoD
PostProcessing.ProMoD.postProcessProMoD(matFilePath);