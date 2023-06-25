function [y] = FIR(B, x)
%UNTITLED4 Summarx of this function goes here
%   Detailed explanation goes here
    xi = zeros(1, length(B));
    for i = 0:(length(xi)-1)
        if (i < (length(x) - 1))
            xi(i + 1) = x(end - i);
        else
            xi(i + 1) = x(1);
        end
    end
    y = B * xi';
end

