clear all, close all, clc;
Fs = 44100;
%N  length will be 0.1 seconds
N = 0.1 * Fs;
Ts = 1/Fs;

%xaxis when plotting DFT
freqBins = linspace(0 ,Fs-1, N);
freqBins = freqBins(1:length(freqBins)/2);

%damping factors
alpha = [100 1000];

%angular frequency
w0 = 2 * pi * 100;

%%alpha 100
x = zeros(N, 1);
%set first two initial positions
x(1) = 1;
%initial veloctiy
v0 = 0.1;
x(2) = x(1) + v0 * Ts;

for n = 3 : N
    x(n) = ( (2 - w0^2 * Ts^2) * x(n-1) + (-1 + alpha(1) * Ts / 2) * x(n-2) )...
            /(1 + alpha(1) * Ts / 2);
end

%% alpha 1000
x2 = zeros(N,1);
x2(1) = 1;
v20 = 1;
x2(2) = x2(1) + v20 * Ts;

for n = 3 : N
    x2(n) = ( (2 - w0^2 * Ts^2) * x2(n-1) + (-1 + alpha(2) * Ts / 2) * x2(n-2))...
            /(1 + alpha(2) * Ts / 2);
end

%% plot x and x2
subplot(1,2,1);
plot(x);
title(strcat('Damped SHO with alpha = ', num2str(alpha(1))));
xlabel('n (samples)');
ylabel('Amplitude');

subplot(1,2,2);
plot(x2);
title(strcat('Damped SHO with alpha = ', num2str(alpha(2))));
xlabel('n (samples)');
ylabel('Amplitude');