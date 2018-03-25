function [y] = allpassTV_s1582241_Karle_Mark( x, R, theta, delta, rate, Fs )
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% This is a function to implement a time varying 2nd order all pass filter
% where x is the input signal vector, Fs is the sample rate,
% and the poles are at (R,theta) and (R,-theta)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Get recursion coefficients from pole positions:    
    N = length(x);
    m= 1:N;
    thetavec = theta + delta * (1 - cos(2*pi*m*rate/Fs));
    y = zeros(N,1);
    
    a1=-2*R*cos(thetavec);
    a2=R^2;
    for n = 3:N
        y(n) = a2 * x(n) + a1(n) * x(n-1) + x(n-2) - a1(n) * y(n-1) - a2 * y(n-2);
    end
end

