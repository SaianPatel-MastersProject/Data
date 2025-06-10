%%
figure("Name", 'Sanity Check');
hold on
plot(lapData.tLap, lapData.CTE, 'LineStyle','-', 'Color', 'black');
s1 = scatter(lapData.tLap(rIdx), lapData.CTE(rIdx), 'filled', 'MarkerFaceColor', 'green', 'SizeData', 12);
s2 = scatter(lapData.tLap(wIdx), lapData.CTE(wIdx), 'filled', 'MarkerFaceColor', 'red', 'SizeData', 12);
s3 = scatter(lapData.tLap(hIdx), lapData.CTE(hIdx), 'filled', 'MarkerFaceColor', 'blue', 'SizeData', 12);
grid on;
grid minor;
set(gca,"TickLabelInterpreter",'latex')
xlabel('Lap Time [s]', 'Interpreter','latex')
ylabel('CTE, $c$ [m]', 'Interpreter','latex')
legend([s1, s2, s3], {'Reducing CTE $c_r$', 'Worsening CTE $c_w$', 'Held CTE $c_h$'}, 'Interpreter','latex')
fontsize(24, "points");