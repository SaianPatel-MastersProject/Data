%% Human Box Plots
figure;
hold on
% b = boxplot([obj.runData(1).metricsCTE.TACTE, obj.runData(2).metricsCTE.TACTE, obj.runData(3).metricsCTE.TACTE], ...
%     'Labels', {'-10%', 'Baseline', '+10%'}, ...
%     'BoxStyle','outline',...
%     'Colors', cmap([1,11,21],:),...
%     'Widths', 0.5);
% b = boxchart([obj.runData(1).metricsCTE.TACTE, obj.runData(2).metricsCTE.TACTE, obj.runData(3).metricsCTE.TACTE], ...
%     'BoxFaceColor', cmap([1],:));
b1 = boxchart((ones([16,1]) * -10),[obj.runData(1).metricsCTE.TACTE], ...
    'BoxFaceColor', cmap([1],:));
b2 = boxchart((ones([16,1])) * -7,[obj.runData(2).metricsCTE.TACTE], ...
    'BoxFaceColor', cmap([4],:));
b3 = boxchart((ones([16,1])) * 0,[obj.runData(3).metricsCTE.TACTE], ...
    'BoxFaceColor', cmap([11],:));
b4 = boxchart((ones([16,1])) * 5,[obj.runData(4).metricsCTE.TACTE], ...
    'BoxFaceColor', cmap([16],:));
b5 = boxchart((ones([16,1])) * 10,[obj.runData(5).metricsCTE.TACTE], ...
    'BoxFaceColor', cmap([21],:));

%% Overlay FFNN
plot((-10:1:10), table2array(metricsCompFFNN(1).avgMetricsVals(2,2)), ...
    'LineStyle', '-', 'Color', 'k', 'LineWidth', 2)
x = (-10:1:10)';
for i = 1:21

    y = table2array(metricsCompFFNN(1).avgMetricsVals(2,2));
    scatter(x(i), y(i),'filled', 'MarkerFaceColor', cmap(i,:), 'SizeData', 144)


end

%% Formatting
grid on;
grid minor;
set(gca,"TickLabelInterpreter",'latex')
xlabel('Steering Sensitivity Delta $\Delta k$ [$\%$]', 'Interpreter','latex', 'FontSize', 24);
ylabel('TACTE $C$ [m/s]', 'Interpreter','latex', 'FontSize', 24);
fontsize(24, "points")
colormap(cmap);
cb = colorbar;
cb.Ticks = [0, 0.5, 1];
cb.TickLabels = [-10, 0, 10];
cb.TickLabelInterpreter = 'latex';
cb.Label.Interpreter = 'latex';
cb.Label.String = 'Steering Sensitivity Delta $\Delta k$ [$\%$]';
cb.FontSize = 14;