%% PostPro
matFilePaths = {
			'D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D4_R01.mat';...
			'D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D4_R02.mat';...

			};

interpType = 'Distance';
interpParam = 0.1;
interpMethod = 'spline';

% Alternative
% interpType = 'Points';
% interpParam = 10000;
% interpMethod = 'spline';

for i = 1:size(matFilePaths,1)

	matFilePath = matFilePaths{i,1};	
	%% Run PE
	PostProcessing.PE.postProcessPE(matFilePath, interpType, interpParam, interpMethod);

	%% Run KAP
	PostProcessing.KAP.postProcessKAP(matFilePath, interpType, interpParam, interpMethod);

	%% Run ProMoD
	PostProcessing.ProMoD.postProcessProMoD(matFilePath);
end