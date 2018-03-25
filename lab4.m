clear all, close all, clc;
Fs = 44100;
Ts = 1.0 / Fs;
filtN = 6;
k = 1:filtN;
h = 0.5 * (1 - cos(2*pi*k/(filtN + 1)));
NFFT = 2^8;
h_padded = [h,zeros(1,NFFT - filtN)];
H = fft(h_padded);
H = H./(max(abs(H)));
fAxis = 0:Fs/length(h_padded):Fs - 1;
figure;
subplot(5,1,1);
stem(h);
title('Impulse Response of a moving average filter based on a Hann window');
xlabel('Time(samples)');
ylabel('Amplitude');

subplot(5,1,2);
title('Impulse Response of a moving average filter based on a Hann window(zero-padded)');
xlabel('Time (samples)');
ylabel('Amplitude');
plot(h_padded);

subplot(5,1,3);
title('Magnitude of Frequency Response H');
plot(fAxis, abs(H));
xlabel('Frequency(Hz)');
ylabel('|H(e^iomegaTs)|(normalized)');

subplot(5,1,4);
title('Magnitude of H in dB');
plot(fAxis, 20 * log10(abs(H)));
xlabel('Frequency(Hz)');
ylabel('|H(e^iomegaTs)|(dB)');

subplot(5,1,5);
title('Frequency response of the above filter (unwrapped phase)');
xlabel('Frequency(Hz)');
ylabel('Phase of H(e^iomegaTs)(radians)');
plot(fAxis, unwrap(angle(H)));