clear all, close all, clc;

Fs = 4000;
N = Fs; %1s of SHO

%xaxis for plotting DFT frequencies
freqBins = linspace(0 ,Fs-1, N);
freqBins = freqBins(1:length(freqBins)/2);

Ts = 1 / Fs;

%set initial position and velocity
x = zeros(N,1);
x(1) = 1;
v0 = 1;
x(2) = x(1) + v0 * Ts;

%desired angular frequency
w0 = 2 * pi * 400;

for n = 3 : N
    x(n) = (2 - w0^2 * Ts^2) * x(n-1) - x(n - 2);
end


%% plot frequency
xF = fft(x);
xF = xF(1:length(freqBins));

%find actual peak frequency
ws = freqBins(abs(xF) == max(abs(xF)));
%difference in Hz between desired and actual angular frequencies
diff = ws - w0/2/pi;

stem(freqBins,abs(xF));
title({strcat('SHO with \omegas at ', num2str(ws), 'Hz'),...
        strcat('Desired w0 is', num2str(w0/2/pi), ' and the difference is ', num2str(diff))});
xlabel('Frequency (Hz)');
ylabel('Amplitude');