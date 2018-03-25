%% initialization
clear all, close all, clc;

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
        N = 1 * Fs;
        x = zeros(N,1);
        x(1) = 1;
end

Ts = 1/Fs;
f0 = 100; %cutoff frequency in Hz
w0 = 2 * pi * f0 / Fs; %angular frequency
%corrected angular frequency
g = 0.9892 * w0 - 0.4342 * w0^2 + 0.1381 * w0^3 - 0.0202 * w0^4;

r = 0.999;%resonance between 0 and 1

out = zeros(size(x)); % output vector

%% main loop
w = zeros(5,1); % state vector
w1 = zeros(5,1); % past state vector

b0 = g / 1.3; %feedforward
b1 = 0.3 / 1.3 * g; %feedforward
a1 = (1 - g); %feedback

A = [-1, 0, 0, -4*r; 1, -1, 0, 0; 0, 1, -1, 0; 0, 0, 1, -1];
B = [1;0;0;0];
C = [0,0,0,1];

u = zeros(4, N);

D = inv((eye(4) - Ts * g  * A * 1/2));
E = (eye(4) + Ts * g * A * 1/2);

for n=1:N
    u(:, n+1) = D * ((E*u(:,n) + Ts * B * x(n)));
end
y = C* u;

soundsc(out,Fs);