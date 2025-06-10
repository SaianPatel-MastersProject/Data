%%
% Number of colors
nColors = 21;

% Define start (blue) and end (red) RGB colors
startColor = [0, 0, 1];   % Blue
endColor   = [1, 0, 0];   % Red

% Linearly interpolate between the two
colors = [linspace(startColor(1), endColor(1), nColors)', ...
          linspace(startColor(2), endColor(2), nColors)', ...
          linspace(startColor(3), endColor(3), nColors)'];