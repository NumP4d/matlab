function [y] = przyrz_pom2(x, b, c, sig, k ,type)
    if (type == "stale")
        z = randn(size(x)) * sig;
    else
        z = randn(size(x)) * sig .* x * k;
    end
    
    y = c(1) + c(2) * (b(1) + b(2) * x + z);
end

