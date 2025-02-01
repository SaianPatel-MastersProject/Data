%% End-to-end track creation from images

% Set the ref points
x0 = -244.5820;
y0 = -1.7150;

x1 = -244.5860;
y1 = -0.9142;

% Set the path to the image
image_path = "C:\Users\Saian\OneDrive - Imperial College London\DE4\Masters\rFpro\AIW\2kF\Iteration 5 - Qatar - True Scale\Qatar.png";

%% 1. Use clicks to set control points

trackPointsOriginal = TrackMaking.fnCreateTrackFromClicks(image_path, x0, y0, x1, y1);

% Save track points original
save('trackPointsOriginal.mat')

%% 2. Smooth the SF Transition

trackPoints = TrackMaking.fnSmoothSF(trackPointsOriginal, 20);

%% 3. Rotate the points to align with the vector (x0, y0) to (x1, y1)

trackPoints = TrackMaking.fnRotateTrackPoints(trackPoints, x0, y0, x1, y1);

%% 4. Translate to start at the specified origin (x0, y0)

trackPoints = TrackMaking.fnTranslateTrackPoints(trackPoints, x0, y0);

%% 5. Scale as needed

% Check the circuit length
dx = [0; diff(trackPoints(:,1))];
dy = [0; diff(trackPoints(:,2))];
d = sqrt(dx.^2 + dy.^2);
dRolling = cumsum(d);
dCircuit = dRolling(end);
dTarget = 4309;
sTarget = dTarget/dCircuit;

%%
trackPoints = TrackMaking.fnScaleTrackPoints(trackPoints, sTarget);

%% Plotting
figure;
hold on
scatter(x0, y0, 'filled', 'MarkerFaceColor', 'r')
scatter(x1, y1, 'filled', 'MarkerFaceColor', 'g')
plot(trackPoints(:,1), trackPoints(:,2), 'Color', 'k');
axis equal

%% 6. Pad the end of the lap

trackPoints = TrackMaking.fnPadEndOfLap(trackPoints, 1);

%% 7. Create Driving Training Line Table

drivingTrainingLine = Utilities.fnCreateDrivingTrainingLinePoints(trackPoints);

% Convert to Table
drivingTrainingLine = array2table(drivingTrainingLine);

% Create csvz
writetable(drivingTrainingLine, 'DrivingLineExport.csv')


%% 8. Plot the Curvature

[kappa, rCurvature] = PostProcessing.PE.fnCalculateCurvature(trackPoints);

figure;
plot(kappa)