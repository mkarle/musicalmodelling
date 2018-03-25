clear all;

[u,Fs] = audioread('pluck.wav');

%Fs = 44100;
f =110;


N = round(Fs/f - 0.5);
rho = 0.98;
R = 0.9;

M = 160000;

%resample u
u = resample(u, N,round(length(u)*1/20));
x = zeros(N,1);
for n = 1:N
    x(n) = (1-R)*u(n) + R*x(max(n-1,1));
end

y = zeros(N+M,1);
y(1:N) = x;

for n = N : length(y)
    y(n)= rho/2 *( y(max(n-N,1)) + y(max(n-(N+1),1)) );
end


soundsc(y,Fs);
y = 2*(y - min(y))/(max(y) - min(y)) - 1;
audiowrite('ksOut_pluck_s1582241_Karle_Mark.wav',y,Fs);