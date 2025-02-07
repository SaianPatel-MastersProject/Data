%% Function to change look-ahead distance as a function of curvature
function [dLook, kappa] = fnLookAheadDistanceSigmoidCurvature(dMin, dMax, a, kappa0, kappa)
    
    % Take the absolute of kappa and get maximum
    kappa = abs(kappa);
    kappaMax = max(kappa);

    % Re-do kappa array
    kappa = linspace(0, kappaMax, 1000);

    % Compute look-ahead distance using the sigmoid function
    dLook = dMin + (dMax - dMin) ./ (1 + exp(a * (kappa - kappa0)));
    
    % Plot results
    % figure;
    % plot(kappa, dLook, 'b', 'LineWidth', 2);
    % xlabel('Curvature \kappa (1/m)');
    % ylabel('Look-Ahead Distance (m)');
    % title('Sigmoid-Based Look-Ahead Distance as a Function of Curvature');
    % grid on;


end