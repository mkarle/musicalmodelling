function [ y ] = vacuumtubeFunction_Karle_Mark( x, G, Q, D, r1, r2 )
%VACUUMTUBEFUNCTION_KARLE_MARK applies the sound of a vacuum tube to input
%x  input signal
%G  distortion factor, pre-gain
%Q  work point
%D  harshness

x_norm = norm(x,Inf);
if x_norm ~= 0
    x = x / norm(x,Inf);
end
x = G * x;

%special case where Q is zero
if Q == 0
    y = x./(1-exp(-D * x)) - 1/D;
else
    y = zeros(size(x));
    xequalsQ = x == Q;
    y(~xequalsQ) = (x(~xequalsQ) - Q) ./ (1 - exp(-D * (x(~xequalsQ) - Q))) + Q / (1 - exp(D * Q));
    %special case where an x value equals Q
    y(xequalsQ) = 1 / D + Q / (1 - exp(D * Q));
end

%apply high pass to remove dc component of y
feedforward_high = [1, -2, 1];
feedback_high = [1, -2 * r1, r1 ^ 2];
y = filter(feedforward_high, feedback_high, y);

% low pass to model capacitance of vacuum tube
feedforward_low = [1 - r2];
feedback_low = [1, -r2];
y = filter(feedforward_low, feedback_low, y);
end

