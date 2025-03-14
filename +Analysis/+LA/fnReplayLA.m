%% Function to replay LA distance
function fnReplayLA(dataLA, AIW_Data)

    figure;
    hold on

    % Plot the track reference
    plot(AIW_Data(:,1), AIW_Data(:,2), 'k--')

    % Set the initial car point and LA point
    carPoint = plot(dataLA(1,1), dataLA(1,2), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    lookAheadPoint = plot(dataLA(1,3), dataLA(1,4), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

    % Set the legend
    legend('Track', 'Car', 'LA Point')
    xlabel('X');
    ylabel('Y');
    grid on;
    grid minor;
    axis equal;

    % Animation loop
    for i = 1:size(dataLA, 1)

        % Update car position
        set(carPoint, 'XData', dataLA(i, 1), 'YData', dataLA(i, 2));
        
        % Update LA point position
        set(lookAheadPoint, 'XData', dataLA(i, 3), 'YData', dataLA(i, 4));
        
        % Update the plot
        drawnow;

        % Control animation speed
        pause(0.05);


    end

    





end