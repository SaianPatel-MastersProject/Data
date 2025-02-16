%% Function to change look-ahead distance as a function of curvature
function [dLook, dKappa] = fnLookAheadDistanceSigmoidCurvature2(dMin, dMax, a, kappa0, kappa)
    
    % Get dKappa (change in curvature)/ 0.1m
    dKappa = [0; diff(kappa)] ./ [0.1];

    % Take the absolute of kappa and get maximum
    dKappa = abs(dKappa);
    % kappa = kappa .^2;
    dKappaMax = max(dKappa);
    dKappaMax = dKappaMax * 2;

    % Re-do kappa array
    dKappa = linspace(0, dKappaMax, 1000);

    % Compute look-ahead distance using the sigmoid function
    dLook = dMin + (dMax - dMin) ./ (1 + exp(a * (dKappa - kappa0)));
    
    % Plot results
    % figure;
    % plot(dKappa, dLook, 'b', 'LineWidth', 2);
    % xlabel('Curvature \kappa (1/m)');
    % ylabel('Look-Ahead Distance (m)');
    % title('Sigmoid-Based Look-Ahead Distance as a Function of Curvature');
    % grid on;


end