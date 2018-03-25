function [ y ] = allpassM_s1582241_Karle_Mark( x, a, M )
    x = [zeros(M,1);x];
    y = zeros(length(x), 1);
    %TODO  make this vectorized
    for n = M + 1:length(x)
        y(n) = a * x(n) + x(n - M) - a * y(n - M);
    end

end

