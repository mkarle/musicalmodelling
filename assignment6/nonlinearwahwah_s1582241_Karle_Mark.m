clear all, close all, clc;
try
    [force,Fs] = audioread('TestGuitarPhraseMono.wav');
catch
    'TestGuitarPhraseMono.wav is not available'
    return;
end

%N  length of the wah wah will be the same as length of the input audio
N = length(force);
Ts = 1/Fs;

%craziness  how wild the resulting sound should be
%really, only <= 1 sounds bearable
craziness = str2double(input('Enter a craziness parameter from 0.01 to 100\n', 's'));
if( isnan(craziness) || craziness  > 100 || craziness < 0.01)
    craziness = 0.01;
end

%use craziness to affect the damping factor
alpha = 0.000001 / craziness;

x = zeros(N, 1);
%initial position of mass
x(1) = 1 + force(1);
%v0     initial velocity
v0 = 0.1;
x(2) = x(1) + v0 * Ts + force(2);

%wah with greater frequency if we want it really crazy
if craziness > 1
    fwah = 3 + log10(craziness);
else
    fwah = 2;
end

%wah with greater range if craziness is high
%wmax   max fundamental frequency
if craziness > 1
    wmax = sqrt(2*pi*2000);
else
    wmax = sqrt(2*pi*1000);
end
%wmin   min fundamental frequency
wmin = sqrt(2*pi*80);

for n = 3 : N
    %save memory by computing w0 each iteration
    w1 = (wmax - wmin) / 2  * cos(2 * pi * fwah * n * Ts) + (wmax - wmin) / 2;
    x(n) = (4 * x(n-1)/ ((1 + alpha/2/Ts)*(2+w1^4 * Ts^2  * x(n-1)^2)) - (1-alpha/2/Ts)/(1+alpha/2/Ts) * x(n-2)) + force(n);

end

%convolve with an amp IR to sound better
amp = audioread('CleanAmpIR.wav');
x = conv(x, amp);
soundsc(x,Fs);
