clear all;

Fs = 44100;
f = 110;


N = round(Fs/f - 0.5);
rho = 0.95;
R = 0.95;

M = 40000;

u = rand(N,1) * 2 - 1;
x = zeros(N,1);
for n = 1:N
    x(n) = (1-R)*u(n) + R*x(max(n-1,1));
end

y = zeros(N+M,1);
y(1:N) = x;

for n = N : length(y)
    y(n)= rho/2 *( y(max(n-N,1)) + y(max(n-(N+1),1)) );
end

y = 2*(y - min(y))/(max(y) - min(y)) - 1;
soundsc(y,Fs);

audiowrite('ksOut_s1582241_Karle_Mark.wav',y,Fs);