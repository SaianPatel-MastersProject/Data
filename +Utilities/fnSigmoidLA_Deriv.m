%% Function to change look-ahead distance as a function of curvature
function [dLook, dKappa] = fnSigmoidLA_Deriv(dMin, dMax, k, dKappaMax, kappa)
    
    % Get the derivative of kappa
    dKappa = [0; diff(kappa)];

    % Fit a cosine wave of the form y = A*cos(Bx+C) +D, between 3 points 
    % (left minimum, central maximum, right minimum)
    
    A = dMax - dMin;
    D = dMin;
    x1 = (dKappaMax)/4;

    dKappa = linspace(0, dKappaMax, 1000);

    dLook = A ./ (1 + exp(-k * (dKappa - x1))) + D;

    % Plot curve

    figure;
    plot(dKappa, dLook, 'b', 'LineWidth', 2); hold on;

    % Plot the given points
    % plot([-dKappaMax, 0, dKappaMax], [dMin, dMax, dMin], 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

    % Labels and grid
    xlabel('dKappa');
    ylabel('dLook');
    title('Cosine Wave Passing Through Given Points');
    grid on;
    grid minor;
   


end