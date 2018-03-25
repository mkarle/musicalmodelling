clear all, close all, clc;

[force, Fs] = audioread('TestGuitarPhraseMono.wav');

Ts = 1/Fs;
N = length(force);

%damping constants
alpha = [5 0 ; 0 1];

%masses
m1 = .005;
m2 = .005;
%mass matrix
M = [m1 0; 0 m2];
%damping matrix
F = -inv(M)* alpha;

%initial positions and velocity
u = zeros(2,N);
u(:,1) = [1;1] + force(1);
v0 = .1;
u(:,2) = u(:,1) + v0 * Ts + force(2) ;

%inverted matrix based on the math to solve for u_n+1
A = inv(eye(2)-F*Ts/2);

%wah frequencies
fwah1 = 2;
fwah2 = 3;
fwah3 = 2;

%spring coefficient maxs and mins
k1max = 2*pi*20000;
k1min = 2*pi*10;
k2max = 2*pi*50000;
k2min = 2*pi*50;
k3max = 2*pi*20000;
k3min = 2*pi*10;
for n = 3:N
    %time varying spring coefficients
    k1 = (k1max - k1min) / 2 *( cos(2 * pi * fwah1 * n * Ts) + 1);
    k2 = (k2max - k2min) / 2 *( cos(2 * pi * fwah2 * n * Ts) + 1);
    k3 = (k3max - k3min) / 2 *( cos(2 * pi * fwah3 * n * Ts) + 1);
    %spring matrix
    D = [k1 + k2, -k2; -k2, k2  +  k3];
    
    E = -inv(M)* D;
    
    %time varying damped double oscillator
    u(:,n) = A*((2* eye(2) + Ts^2 * E) * u(:,n-1) +(-eye(2) - Ts/2 * F) * u(:,n-2)) + force(n);

    
end

try
    amp = audioread('CleanAmpIR.wav');
    left = conv(u(1,:),amp);
    right = conv(u(2,:),amp);
    u = [left;right];
catch
    'Could not convolve with an amp IR'
end

soundsc(u,Fs);