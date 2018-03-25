function [ y ] = feedforcomb_s1582241_Karle_Mark( x, b, M )
    y = zeros(length(x), 1);
    %TODO vectorize
    for n = M + 1:length(x)
        y(n) = x(n) + b * x(n-M);
    end

end

