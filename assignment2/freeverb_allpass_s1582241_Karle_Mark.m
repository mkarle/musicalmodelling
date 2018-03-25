function [ y ] = freeverb_allpass_s1582241_Karle_Mark( x, a, M )

    y = zeros(length(x),1);
    % according to the transfer function at 
    % https://ccrma.stanford.edu/~jos/pasp/Freeverb_Allpass_Approximation.html
    % This is the allpass filter that freeverb uses.
    for n = M + 1: length(x)
        y(n) = x(n) + (1 + a)* x(n-M) - a * y(n-M);
    end
end

