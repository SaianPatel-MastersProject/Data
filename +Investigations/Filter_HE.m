%% Filtering Heading Error

%% Load Data
obj = Plotting.multiPlotter();
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', 31); % Human

%% Extract HE Channel
HE = obj.data(1).lapData.HeadingError;
nEntries = size(HE, 1);

%% Moving Average Filter - Sliding Window
HE_filt_1 = movmean(HE, 51);

%% Moving Average Filter - Sliding Window
HE_filt_1b = zeros([nEntries, 1]);
n = 5;

for k = n:length(HE)
    HE_filt_1b(k) = mean(HE(k-n+1:k));
end




%% Moving Average Filter - Exponential Weighting
alpha = 0.3;
HE_filt_2 = zeros([nEntries, 1]);

for i = 2:nEntries

    HE_filt_2(i,1) = alpha * HE(i,1) + (1 - alpha) * HE_filt_2(i-1, 1);

end

%% Low-Pass Filter - Exponential
Ts = 0.01;
tau = 0.01;
alpha = Ts / (tau + Ts);
b = Ts;
a = [Ts+tau, -tau];
HE_filt_3 = filter(b, a, HE);

%% Plotting
figure;
% Plot HE
subplot(2,1,1)
hold on
plot(HE, 'Color', 'k')
plot(HE_filt_1, 'Color', 'b')
plot(HE_filt_1b, 'Color', 'r')
% plot(HE_filt_3, 'Color', 'g')

% Plot dHE
subplot(2,1,2)
hold on
plot([0; diff(HE)], 'Color', 'k')
% plot([0; diff(HE_filt_3)], 'Color', 'g')
plot([0; diff(HE_filt_1)], 'Color', 'b', 'LineWidth', 2)
plot([0; diff(HE_filt_1b)], 'Color', 'r')
