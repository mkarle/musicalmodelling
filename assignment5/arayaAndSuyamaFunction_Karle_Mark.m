function [ y ] = arayaAndSuyamaFunction_Karle_Mark( x )
%ARAYAANDSUYAMAFUNCTION applies the nonlinear function three times to an
%input
%math operation found from PDF in Distortion Resources on Learn
%and is designed by Araya and Suyama 
%x  audio input signal

%normalize x
x_norm = norm(x,Inf);
if x_norm ~= 0
    x = x/norm(x,Inf);
end

y = x;
%since the function is not hugely nonlinear, apply it three times
for n = 1:3
    y = 3/2 * y .* (1 - y.^2/3);
end
end

