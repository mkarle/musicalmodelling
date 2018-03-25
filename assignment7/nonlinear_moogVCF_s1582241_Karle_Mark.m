%% initialization
clear all, close all, clc;

inputType = 1;

f0 = 200; %cutoff frequency in Hz
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
        N = 1 * Fs;
        x = 0:1/Fs:1;
        x = sin(2*pi*f0*x);
end

gain = 4; %nonlinear gain
x = x./norm(x,Inf); %normalize x
x = x * gain;
sampleFactor = 1; %upsampling kind of screws it up actually
x = interp(x, sampleFactor);
w0 = 2 * pi * f0 / Fs; %angular frequency
%corrected angular frequency
g = 0.9892 * w0 - 0.4342 * w0^2 + 0.1381 * w0^3 - 0.0202 * w0^4;

r = .1;%resonance between 0 and 1
out = zeros(size(x)); % output vector

%% main loop
w = zeros(5,1); % state vector
w1 = zeros(5,1); % past state vector

b0 = g / 1.3; %feedforward
b1 = 0.3 / 1.3 * g; %feedforward
a1 = (1 - g); %feedback
for n = 1 : N
    w(1) = x(n) - 4 * r * w1(5);
    w(1) = tanh(gain* w(1));
    for k = 2 : 5
        w(k) = b0 * w(k - 1) + b1 * w1(k - 1) + a1 * w1(k);
        w(k) = tanh(w(k)); %clip at each state
    end
    out(n) = w(5);
    w1 = w;
end


out = decimate(out, sampleFactor);

soundsc(out,Fs);