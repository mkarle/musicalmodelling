function [ y ] = lowpasscomb_s1582241_Karle_Mark( x, d, f, M  )

    y = zeros(length(x), 1);
    for n = M+1:length(x)
        y(n) = (1-d)*x(n) - d * y(n-M);
    end
    
    for n = M+1:length(x)
        y(n) = x(n-M) - f * y(n) * y(n-M);
    end

end

