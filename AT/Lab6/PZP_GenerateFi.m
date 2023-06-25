function [fi] = PZP_GenerateFi(u, y, k, nB, nA)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    ui = zeros(1, k + nB);
    yi = zeros(1, nA);
    for i = 0:(length(ui)-1)
        if (i < (length(u) - 1))
            ui(i + 1) = u(end - i);
        else
            ui(i + 1) = u(1);
        end
    end
    for i = 0:(length(yi)-1)
        if (i < (length(y) - 1))
            yi(i + 1) = y(end - i);
        else
            yi(i + 1) = y(1);
        end
    end
    fi = [ui(1:(end-k+1)), -yi]';
end

