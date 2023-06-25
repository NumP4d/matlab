function [J] = J(u)
    x = zeros(length(u)+1, 1);
    
    x(1) = 50;
    
    for i = 1:9
        x(i+1) = x(i) - u(i);
    end
    
    J = sum(x(1:(end-1)).^2 + 0.5 .* u.^2);
end

