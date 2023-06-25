function [x_n, y_n] = Plant(xi, ui, A, B, C, D, Ts)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    x_n = Ts * (A * xi + B * ui) + xi;
    y_n = C * xi + D * ui;
end

