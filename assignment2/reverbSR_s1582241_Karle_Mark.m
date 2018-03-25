[x, Fs] = audioread('../audio/02 10,000 Emerald Pools.m4a');

if size(x,2) ==2
    x = (x(:,1) + x(:,2))/2;
end

% a could be changed to a matrix but since we're only using one value,
% there's no reason to.
a = 0.7;
M = [1051 337 113];

y = x;
for n = 1:length(M)
    y = allpassM_s1582241_Karle_Mark(y, a, M(n));
end
b = [0.742 0.733 0.715 0.697];
M = [4799 4999 5399 5801];
allpassY = y;
for n=1:length(b)
    y = y + feedforcomb_s1582241_Karle_Mark(allpassY, b(n), M(n));
end
y = y./max(abs(y));
audiowrite('output.wav', y, Fs);
sound(y, Fs);