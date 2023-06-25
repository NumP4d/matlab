function [x_n, y_n] = Plant(xi, u, A, B, C, D, Delay, Ts)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    k = ceil(Delay / (Ts * 100));
    if (k > (length(u) - 1))
        ui = u(1);
    else
        ui = u(end - k);
    end
    x_n = Ts * (A * xi + B * ui) + xi;
    y_n = C * xi + D * ui;
end

