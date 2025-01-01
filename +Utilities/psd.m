%% Example signal (replace this with your actual signal)
Fs = 100;  % Sampling frequency (Hz)
t = obj.data(1).lapData.time;
x = obj.data(1).lapData.steerAngle;

% Compute PSD
window = hamming(256);    % Window function
noverlap = 128;           % Number of overlapping samples
nfft = 512;               % FFT points
[pxx, f] = pwelch(x, window, noverlap, nfft, Fs);

%% Plot the PSD
figure;
plot(f, 10*log10(pxx));  % Convert to dB
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of the Signal');
grid on;

%%
figure;
spectrogram(x, window, noverlap, nfft, Fs, 'yaxis');
colormap jet;             % Optional: Set colormap
colorbar;                 % Display color scale
title('Spectrogram');
ylabel('Frequency (Hz)');
xlabel('Time (s)');