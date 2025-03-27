% Sample frequency is 100Hz
t = (0:0.1:100);
fs = 1/0.1;

% Frequency of x, y is 1Hz
x = sin(2*pi*t);
y = 3.5*cos(2*pi*t);

nSamples = length(x);
fftLength = 512;
windowVector = hanning(fftLength)*2;
nOverlap = ceil(7*fftLength/8);
[txy,tf] = tfestimate(x,y,windowVector,nOverlap,fftLength,fs);
% txy = txy .* ((1j .* 2 .* pi .* tf) .^ 1); % If wanting to look at derivatives
[coh, freq] = mscohere(x,y,windowVector,nOverlap,fftLength,fs);

figure;
subplot(4,1,1)
hold on
plot(t,x)
plot(t,y)

subplot(4,1,2)
hold on
plot(tf, abs(txy))
xlabel('Frequency (Hz)')
ylabel('Magnitude')

subplot(4,1,3)
hold on
plot(tf, (angle(txy)))
xlabel('Frequency (Hz)')
ylabel('Phase Angle')

subplot(4,1,4)
hold on
plot(freq, coh)
xlabel('Frequency (Hz)')
ylabel('Coherence')
