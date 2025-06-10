%% Function to change look-ahead distance as a function of curvature
function [dLook, dKappa] = fn_dLAdCurvature(dMin, dMax, a, kappa0, dKappa)
    
    % Take the derivative of kappa
    dKappa = [0; diff(dKappa)];

    % Square dKappa
    dKappa = dKappa .^ 2;

    dKappaMax = max(dKappa);

    % Re-do kappa array
    dKappa = linspace(0, dKappaMax, 1000);

    % Compute look-ahead distance using the sigmoid function
    dLook = dMin + (dMax - dMin) ./ (1 + exp(a * (dKappa - kappa0)));
    
    % Plot results
    figure;
    plot(dKappa, dLook, 'b', 'LineWidth', 2);
    xlabel('Curvature \kappa (1/m)');
    ylabel('Look-Ahead Distance (m)');
    title('Sigmoid-Based Look-Ahead Distance as a Function of Curvature');
    grid on;


end