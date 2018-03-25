clear all, close all, clc;

try
    [force,Fs] = audioread('TestGuitarPhraseMono.wav');
catch
    'Cannot find TestGuitarPhraseMono.wav'
    return;
end

%N  length of vector we need to calculate wahwah effect
N = length(force);
Ts = 1/Fs;

%alpha   damping factor, higher reduces wah effect
alpha = 2000;

x = zeros(N, 1);
%initial position
x(1) = 1 + force(1);
%initial velocity
v0 = 0.1;
x(2) = x(1) + v0 * Ts + force(2);

%fwah   how many times a second to wah
fwah = 2;
%maximum frequency of wah
wmax = 2*pi*2000;
%minimum frequency of wah
wmin = 2*pi*100;
for n = 3 : N
    %calculate w0 in loop to save space. outside of loop speeds it up
    w0 = (wmax - wmin) / 2 * cos(2 * pi * fwah * n * Ts) + (wmax - wmin) / 2;
    %add force, the input audio, to add the wah effect to it
    x(n) = 1*( (2 - w0^2 * Ts^2) * x(n-1) + (-1 + alpha * Ts / 2) * x(n-2))...
            /(1 + alpha * Ts / 2) +force(n);
end

%convolve with an amp IR to sound better
amp = audioread('CleanAmpIR.wav');
x = conv(x, amp);
soundsc(x,Fs);
