%% PID Box Plot
figure;
hold on
cteTrip = [
    metricsComp(1).avgMetricsVals(12, 2); ...
    metricsComp(1).avgMetricsVals(13, 2); ...
    metricsComp(1).avgMetricsVals(14, 2); ...
];
cteTrip = (table2array(cteTrip))';

barColours = [
    0 1 0;... % Green
    1 0 0;... % Red
    0 0 1;... % Blue
];

bP = bar(cteTrip, 'stacked');
for i = 1:size(cteTrip, 2)

    bP(i).FaceColor = barColours(i,:);

end

grid on;
grid minor;

set(gca,"TickLabelInterpreter",'latex');
legend({'Reducing CTE, $c_r$', 'Worsening CTE, $c_w$', 'Held CTE, $c_w$'}, 'Interpreter','latex');
ylabel('Proportion of Lap [$\%$]', 'Interpreter', 'latex');
xlabel('Driver', 'Interpreter','latex');
fontsize(24, "points")
ylim([0,100])