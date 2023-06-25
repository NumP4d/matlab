function [A, B, C, D] = TranslateModel(k, T)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    % Plant definition
    A = -1 / T;
    B = k / T;
    C = 1;
    D = 0;
end

