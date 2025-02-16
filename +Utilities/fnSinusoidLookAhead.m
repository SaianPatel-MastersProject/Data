%% Function to change look-ahead distance as a function of curvature
function [dLook, dKappa] = fnSinusoidLookAhead(dMin, dMax, dKappaMax, kappa)
    
    % Get the derivative of kappa
    dKappa = [0; diff(kappa)];

    % Fit a cosine wave of the form y = A*cos(Bx+C) +D, between 3 points 
    % (left minimum, central maximum, right minimum)
    
    D = (dMax + dMin)/2;

    A = dMax - D;

    B = pi / (dKappaMax);

    C = 0;

    dKappa = linspace(-dKappaMax, dKappaMax, 1000);

    dLook = A * cos(B * dKappa + C) + D;

    % Plot curve
    figure;

    figure;
    plot(dKappa, dLook, 'b', 'LineWidth', 2); hold on;

    % Plot the given points
    plot([-dKappaMax, 0, dKappaMax], [dMin, dMax, dMin], 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

    % Labels and grid
    xlabel('dKappa');
    ylabel('dLook');
    title('Cosine Wave Passing Through Given Points');
    grid on;
    grid minor;
   


end