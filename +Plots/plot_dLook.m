%%

% Create dLook Sigmoid
[dLookOverall, kappaSorted] = Utilities.fnLookAheadDistanceSigmoidCurvature(6, 30, 1000, 0.005, kappaInterp);
% [dLookOverall, kappaSorted] = Utilities.fnLookAheadDistanceSigmoidCurvature(6, 30, 200, 0.01, kappaInterp);
dLook_H = interp1(kappaSorted, dLookOverall, abs(obj.data(1).lapData.kappa));
dLook_NN = interp1(kappaSorted, dLookOverall, abs(obj.data(2).lapData.kappa));

% dLook_H = interp1(kappaSorted, dLookOverall, (obj.data(1).lapData.kappa).^2);
% dLook_NN = interp1(kappaSorted, dLookOverall, (obj.data(2).lapData.kappa).^2);

%% Plotting
figure;
plot(obj.data(1).lapData.lapDist, dLook_H)
hold on
plot(obj.data(2).lapData.lapDist, dLook_NN)


%%
figure;
scatter(abs(obj.data(1).lapData.kappa), dLook_H);
hold on
scatter(abs(obj.data(2).lapData.kappa), dLook_NN);

%%
dKappaInterp = [0; diff(kappaInterp)];
[dLookOverall, kappaSorted] = Utilities.fnSinusoidLookAhead(6, 60, 6e-4,kappaInterp./2.5e-3);

dLook_H = interp1(kappaSorted, dLookOverall, [0; diff(obj.data(1).lapData.kappa)]);
dLook_NN = interp1(kappaSorted, dLookOverall, [0; diff(obj.data(2).lapData.kappa)]);

figure;
plot(obj.data(1).lapData.lapDist, dLook_H)
hold on
plot(obj.data(2).lapData.lapDist, dLook_NN)

figure;
scatter([0; diff(obj.data(1).lapData.kappa)], dLook_H);
hold on
scatter([0; diff(obj.data(2).lapData.kappa)], dLook_NN);

%%
dKappaInterp = [0; diff(kappaInterp)];
[dLookOverall, kappaSorted] = Utilities.fnSigmoidLA_Deriv(60, 6, 10000, 1.5e-3,kappaInterp);

dKappa_1 = [0; diff(obj.data(1).lapData.kappa)] ./ [1; diff(obj.data(1).lapData.lapDist)];
dKappa_2 = [0; diff(obj.data(2).lapData.kappa)] ./ [1; diff(obj.data(2).lapData.lapDist)];

dLook_H = interp1(kappaSorted, dLookOverall, abs(dKappa_1));
dLook_NN = interp1(kappaSorted, dLookOverall, abs(dKappa_2));

figure;
plot(obj.data(1).lapData.lapDist, dLook_H)
hold on
plot(obj.data(2).lapData.lapDist, dLook_NN)


figure;
scatter([0; diff(obj.data(1).lapData.kappa)], dLook_H);
hold on
scatter([0; diff(obj.data(2).lapData.kappa)], dLook_NN);