function [ y ] = doidic_Karle_Mark( x, G )
%DOIDIC_KARLE_MARK applies an asymmetric nonlinear piecewise function to x
%math operation found from PDF in Distortion Resources on Learn
%and is designed by Doidic et al
%x  audio input signal
%G  distortion gain

%normalize x
x_norm = norm(x,Inf);
if x_norm ~= 0
    x = x/norm(x,Inf);
end
x = G *x;

y = zeros(size(x));

y(x<-0.08905) = -3/4 * (1 - (1 - (abs(x(x<-0.08905)) - 0.032847)).^12 +...
    1/3*(abs(x(x<-0.08905)) - 0.032847)) + 0.01;

y(x>=-0.08905 & x < 0.320018) = -6.153 * x(x>=-0.08905 & x < 0.320018).^2 ...
    + 3.9375 * x(x>=-0.08905 & x < 0.320018);

y(x >= 0.320018) = 0.630035;
end

