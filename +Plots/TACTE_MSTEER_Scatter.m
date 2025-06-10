%% TACTE MSTEER SCATTER
x = (-10:1:10)';
N = numel(x);
cmap = [linspace(0,1,N)', zeros(N,1), linspace(1,0,N)'];  % RGB values

%% Plotting
figure;
% subplot(1,2,1);
% hold on
% grid on
% grid minor
% y = table2array(metricsCompFFNN(1).avgMetricsVals(2,2));
% plot(x,y, 'k--', 'LineWidth', 2)
% 
% for i = 1:N
% 
%     scatter(x(i), y(i),'filled', 'MarkerFaceColor', cmap(i,:), 'SizeData', 144)
% 
% 
% end
% 
% set(gca,"TickLabelInterpreter",'latex')
% xlabel('Steering Sensitivity Delta $\Delta k$ [$\%$]', 'Interpreter','latex', 'FontSize', 24);
% ylabel('TACTE $C$ [m]', 'Interpreter','latex', 'FontSize', 24);

% subplot(1,2,2);
hold on
grid on
grid minor
y = table2array(metricsCompFFNN(2).avgMetricsVals(8,2));
plot(x,y, 'k--', 'LineWidth', 2)

for i = 1:N

    scatter(x(i), y(i),'filled', 'MarkerFaceColor', cmap(i,:), 'SizeData', 144)


end

set(gca,"TickLabelInterpreter",'latex')
xlabel('Steering Sensitivity Delta $\Delta k$ [$\%$]', 'Interpreter','latex', 'FontSize', 24);
ylabel('Steering Smoothness $M_\delta$ [deg/s]', 'Interpreter','latex', 'FontSize', 24);
colormap(cmap);
cb = colorbar;
cb.Ticks = [0, 0.5, 1];
cb.TickLabels = [-10, 0, 10];
cb.Label.String = 'Steering Sensitivity Delta $\Delta k$ [$\%$]';