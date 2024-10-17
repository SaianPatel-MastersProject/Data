%% Set FilePath to data
dataFilePath = 'Arrow Speedway-20241017_174309.csv';

%% Create Plotter object
obj = Plotting.rFproDataPlotter(dataFilePath);

%% Get Channels
obj = obj.getChannels();

%% Get Laps
obj = obj.getLapNumbers();

%% Filter by lap (1st Flying)
obj = obj.filterByLap(obj.lapNumbers(2));

%% Plot Fundamentals
obj.plotFundamentals();

%% Plot Racing Line
obj.plotRacingLine();

%% Plot Combined Throttle
obj.plotCombinedTraction();

%% Plot Combined Brake
obj.plotCombinedBraking();