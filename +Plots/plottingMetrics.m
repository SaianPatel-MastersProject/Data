%% Metrics Plotting

runsToPlot ={
    '+ProcessedData\2024\FYP12_09\2024_FYP12_09_D4_R01.mat';
    '+ProcessedData\2024\FYP12_09\2024_FYP12_09_D4_R02.mat';
};

for i = 1:size(runsToPlot, 1)

    % load the run
    load(runsToPlot{i});

    % get a lap summary table for the run
    lapSummary_i = PostProcessing.ProMoD.calculateLapSummaryMetrics(runStruct);

    if i == 1

        % Create the table
        lapSummary = lapSummary_i;

    else

        % Append to the table
        lapSummary = [lapSummary; lapSummary_i];

    end


end

%% Split the data by driver

driverList = unique(lapSummary.driver);
nDrivers = size(driverList, 1);

lapSummaryStruct = struct();

for i = 1:size(driverList, 1)

    driver_i = driverList{i};

    lapSummary_i = lapSummary(strcmp(lapSummary.driver, driver_i), :);

    driverTableName = sprintf('lapSummary_%s', driver_i);

    eval([driverTableName '= lapSummary_i;'])

end

%% Plotting
figure;

subplot(3,3,1);
hold on;

for i = 1:nDrivers

    scatter(lapSummary.minSteerAngle(strcmp(lapSummary.driver, driverList{i})), lapSummary.maxSteerAngle(strcmp(lapSummary.driver, driverList{i})));
    grid on;
    grid minor;
    xlabel('Minimum Steering Angle (°)')
    ylabel('Maximum Steering Angle (°)')
    
end

subplot(3,3,2);
hold on;

for i = 1:nDrivers

    scatter(lapSummary.min_dSteerAngle(strcmp(lapSummary.driver, driverList{i})), lapSummary.max_dSteerAngle(strcmp(lapSummary.driver, driverList{i})));
    grid on;
    grid minor;
    xlabel('Minimum Steering Angle Derivative (°/s)')
    ylabel('Maximum Steering Angle Derivative (°/s)')
    
end

subplot(3,3,3);
hold on;

for i = 1:nDrivers

    scatter(lapSummary.avgSteerAngle(strcmp(lapSummary.driver, driverList{i})), lapSummary.avg_dSteerAngle(strcmp(lapSummary.driver, driverList{i})));
    grid on;
    grid minor;
    xlabel('Average Steering Angle (°)')
    ylabel('Average Steering Angle Derivative (°/s)')
    
end

subplot(3,3,4);
hold on;

for i = 1:nDrivers

    scatter(lapSummary.maxSteerAngle(strcmp(lapSummary.driver, driverList{i})), lapSummary.max_dSteerAngle(strcmp(lapSummary.driver, driverList{i})));
    grid on;
    grid minor;
    xlabel('Maximum Steering Angle (°)')
    ylabel('Maximum Steering Angle Derivative (°/s)')
    
end

subplot(3,3,5);
hold on;

for i = 1:nDrivers

    scatter(lapSummary.minSteerAngle(strcmp(lapSummary.driver, driverList{i})), lapSummary.min_dSteerAngle(strcmp(lapSummary.driver, driverList{i})));
    grid on;
    grid minor;
    xlabel('Minimum Steering Angle (°)')
    ylabel('Minimum Steering Angle Derivative (°/s)')
    
end

subplot(3,3,6);
hold on;

for i = 1:nDrivers

    scatter(lapSummary.MSteer(strcmp(lapSummary.driver, driverList{i})), lapSummary.min_dSteerAngle(strcmp(lapSummary.driver, driverList{i})));
    grid on;
    grid minor;
    xlabel('MSteer')
    ylabel('Minimum Steering Angle Derivative (°/s)')
    
end

subplot(3,3,7);
hold on;

for i = 1:nDrivers

    scatter(lapSummary.TACTE(strcmp(lapSummary.driver, driverList{i})), lapSummary.min_dSteerAngle(strcmp(lapSummary.driver, driverList{i})));
    grid on;
    grid minor;
    xlabel('Total Absolute CTE')
    ylabel('Minimum Steering Angle Derivative (°/s)')
    
end

subplot(3,3,8);
hold on;

for i = 1:nDrivers

    scatter(lapSummary.avgCTE(strcmp(lapSummary.driver, driverList{i})), lapSummary.min_dSteerAngle(strcmp(lapSummary.driver, driverList{i})));
    grid on;
    grid minor;
    xlabel('Average CTE')
    ylabel('Minimum Steering Angle Derivative (°/s)')
    
end

subplot(3,3,9);
hold on;

for i = 1:nDrivers

    scatter(lapSummary.avgCTE(strcmp(lapSummary.driver, driverList{i})), lapSummary.avg_dSteerAngle(strcmp(lapSummary.driver, driverList{i})));
    grid on;
    grid minor;
    xlabel('Average CTE')
    ylabel('Average Steering Angle Derivative (°/s)')
    
end