%%
obj = Plotting.multiPlotter();

% Add training run

obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R02.mat', true, [10:25]); % SP k =-1.425

obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D4_R02.mat', true, [2:17]); % SP k =-1.425

obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R04.mat', true, [1:16]); % SP k=-1.5

% obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R14.mat', true, [6:21]); % SP k=-1.5

obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R13.mat', true, [6:21]); % SP k =-1.425



obj = obj.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R03.mat', true, [8:23]); % SP k =-1.575



% Add reference lap
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R02.mat', 25); % SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R04.mat', 16); % SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R14.mat', 21); % SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R13.mat', 21); % SP
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R03.mat', 23); % SP

% Overwrite the legend cell
obj.plottingTools.legendCell = {'-10%', 'Baseline', '+5%', '+10%'};

%%
objFFNN = Plotting.multiPlotter();

% Add training run
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R05.mat', true, [2:4]); % -10
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R01.mat', true, [2:4]); % -9
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R02.mat', true, [2:4]); % -8
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R03.mat', true, [2:4]); % -7
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R04.mat', true, [2:4]); % -6
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R08.mat', true, [2:4]); % -5
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R05.mat', true, [2:4]); % -4
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R06.mat', true, [2:4]); % -3
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R07.mat', true, [2:4]); % -2
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R08.mat', true, [2:4]); % -1
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R06.mat', true, [2:4]); % 0
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R10.mat', true, [2:4]); % +1
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R09.mat', true, [2:4]); % +2
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R10.mat', true, [2:4]); % +3
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R11.mat', true, [2:4]); % +4
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R09.mat', true, [2:4]); % +5
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R12.mat', true, [2:4]); % +6
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R13.mat', true, [2:4]); % +7
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R14.mat', true, [2:4]); % +8
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R15.mat', true, [2:4]); % +9
objFFNN = objFFNN.addRun('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R07.mat', true, [2:4]); % +10


% Add reference lap
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R05.mat', 4); %-10
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R01.mat', 4); %-9
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R02.mat', 4); %-8
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R03.mat', 4); %-7
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R04.mat', 4); %-6
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R08.mat', 4); %-5
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R05.mat', 4); %-4
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R06.mat', 4); %-3
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R07.mat', 4); %-2
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R08.mat', 4);  %-1
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R06.mat', 4); %0
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R10.mat', 4); %+1
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R09.mat', 4); %+2
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R10.mat', 4); %+3
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R11.mat', 4); %+4
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R09.mat', 4); %+5
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R12.mat', 4); %+6
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R13.mat', 4); %+7
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R14.mat', 4); %+8
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D3_R15.mat', 4); %+9
objFFNN = objFFNN.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP05_19\2025_FYP05_19_D2_R07.mat', 4); %+10


%% Overwrite the legend cell
nLaps = size(objFFNN.data, 2);
setupVals = (-10:1:10)';
legendCell = {};
for i = 1:nLaps

    legendCell{1,i} = sprintf('%i', setupVals(i));

end
objFFNN.plottingTools.legendCell = legendCell;