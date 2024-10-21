%% Script to get the fft of two runs

mP = Plotting.multiPlotter();

% SP
mP = mP.addLap('+ProcessedData/Arrow Speedway-20241019_114211.mat', 12);

% AI
mP = mP.addLap('+ProcessedData/Arrow Speedway-20241019_151143.mat', 2);

d1 = mP.data(1).lapData.throttle;
d2 = mP.data(2).lapData.throttle;

Fs = 100;
T = 1/Fs;

figure;
hold on

for j = 1:2

    signal = mP.data(j).lapData.throttle;
    L = size(signal, 1);  % Number of samples (length of time series)
    t = (0:L-1) * T;  % Time vector

    % Apply FFT to each column of your data
    n_signals = size(signal, 2);  % Number of columns (features)
    for i = 1:n_signals

        % Extract the ith signal (e.g., steering angle or throttle data)
        x = signal(:, i);

        % Apply FFT
        Y = fft(x);

        % Compute the two-sided spectrum
        P2 = abs(Y/L);  % Two-sided spectrum
        P1 = P2(1:L/2+1);  % Single-sided spectrum (positive frequencies)
        P1(2:end-1) = 2*P1(2:end-1);  % Scaling the single-sided spectrum

        % Frequency axis
        f = Fs*(0:(L/2))/L;

        % Plot the FFT
        plot(f, P1);
        title(['Single-Sided Amplitude Spectrum of Signal ', num2str(i)]);
        xlabel('Frequency (Hz)');
        ylabel('|P1(f)|');
    end

end