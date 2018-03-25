%% initialization
clear all, close all, clc;

% choose either 0 or nonzero to switch from an audio file to an impulse
inputType = 1;

switch inputType
    case 0
        try
            [x, Fs] = audioread('TestGuitarPhraseMono.wav');
            N = length(x);
        catch
            disp('Could not read audio file');
            return;
        end
    otherwise
        Fs = 44100;
        N = 1 * Fs;%1 second of impulse
        t = (0:N-1)';
        x = cos(2*pi*100*t);
end


f0 = 400; %cutoff frequency in Hz
w0 = 2 * pi * f0 / Fs; %angular frequency
%corrected angular frequency
g = 0.9892 * w0 - 0.4342 * w0^2 + 0.1381 * w0^3 - 0.0202 * w0^4;

r = 0.99;%resonance between 0 and 1

out = zeros(size(x)); % output vector

%% main loop
w = zeros(5,1); % state vector
w1 = zeros(5,1); % past state vector

b0 = g / 1.3; %feedforward
b1 = 0.3 / 1.3 * g; %feedforward
a1 = (1 - g); %feedback
for n = 1 : N
    w(1) = x(n) - 4 * r * w1(5);
    
    w(2) = b0 * w(1) + b1 * w1(1) + a1 * w1(2);
    w(3) = b0 * w(2) + b1 * w1(2) + a1 * w1(3);
    w(4) = b0 * w(3) + b1 * w1(3) + a1 * w1(4);
    w(5) = b0 * w(4) + b1 * w1(4) + a1 * w1(5);
    out(n) = w(5);
    w1 = w;
end

%% plots

subplot(2, 1, 1);
plot(linspace(0, N/Fs, N),out);
title('Time Domain Output');
xlabel('Time (in samples)');
ylabel('Amplitude');


subplot(2,1,2);
freqBins = linspace(0, Fs, N);
freqBins = freqBins(1:length(freqBins)/2); %go up to Nyquist
outF = fft(out);
outF = outF(1:length(outF)/2); %go up to Nyquist
plot(freqBins,20*log10(abs(outF)));
title('Frequency Domain Output');
xlabel('Frequency (Hz)');
ylabel('Amplitude (dB)');

soundsc(out,Fs);