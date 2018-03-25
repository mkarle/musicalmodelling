function [y] = allpass_s1582241_Karle_Mark( x, R, theta )
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% This is a function to implement a non-time varying 2nd order all pass filter
% where x is the input signal vector
% and the poles are at (R,theta) and (R,-theta)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Get recursion coefficients from pole positions:
    a1=-2*R*cos(theta);
    a2=R^2;
    
    [N, M] = size(x);
    y = zeros(N,M);
    
    %in case multiple channels are passed to this function, loop over second dimension.
    %The test doesn't pass multiple channels in, but if it did, this would apply the
    %same filter to both channels.
    for i = 1:M
        for n = 3:N
            y(n,i) = a2 * x(n,i) + a1 * x(n-1,i) + x(n-2,i) - a1 * y(n-1,i) - a2 * y(n-2,i);
        end
    end
end

