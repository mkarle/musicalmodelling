function [ y ] = fuzzyFunction_Karle_Mark( x, G, Fs )
%FUZZY applies a 'fuzz' effect to the input signal
% x     input signal
% G     Distortion parameter
% Fs    Sampling rate

%normalize x and multiply by G
x = x./norm(x,Inf);
x = G * x;

%compute the effect without oversampling so we can plot and see the
%differences
nonnegative_origSampling = x >= 0;
y_origSampling(nonnegative_origSampling) = 1 - exp(-x(nonnegative_origSampling));
y_origSampling(~nonnegative_origSampling) = -(1 - exp(x(~nonnegative_origSampling)));

%r  oversampling factor
r = 8;
y = upsample(x, r);

%clip y
%use signum function to speed things up
y = sign(y).*(1-exp(-sign(y).*y));
%downsample back to Fs
y = downsample(y, r);


%% Time plots
figure;
subplot(2, 3, 1);
plot(x);
title('Undistorted - Time Domain');
xlabel('Time (samples)');
ylabel('Amplitude');

subplot(2, 3, 2);
plot(y_origSampling);
title('Distorted without oversampling - Time Domain');
xlabel('Time (samples)');
ylabel('Amplitude')

subplot(2, 3, 3);
plot(y);
title(strcat('Distorted with oversampling by ', num2str(r), ' - Time Domain'));
xlabel('Time (samples)');
ylabel('Amplitude');

%% Frequency plots
freqBins = linspace(1, Fs -1,length(x));

subplot(2, 3, 4);
xF = fft(x);
plot(freqBins, abs(xF));
title('Undistorted - Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Amplitude');


subplot(2, 3, 5);
y_origSamplingF = fft(y_origSampling);
plot(freqBins, abs(y_origSamplingF));
title('Distorted without oversampling - Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Amplitude');


subplot(2, 3, 6);
yF = fft(y);
plot(freqBins, abs(yF));
title(strcat('Distorted with oversampling by ', num2str(r), ' - Frequency Domain'));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
end

