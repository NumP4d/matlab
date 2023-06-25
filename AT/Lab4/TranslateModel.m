function [A, B, C, D] = TranslateModel(k, T1, T2)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    % Plant setup
    a11 = -1 / T1;
    a12 = 0;
    a21 = 1 / T2;
    a22 = -1 / T2;
    b1  = k / T1;
    b2  = 0;
    c1  = 0;
    c2  = 1;
    d   = 0;

    % Plant definition
    A = [a11, a12;
         a21, a22];
    B = [b1;
         b2];
    C = [c1, c2];
    D = d;
end

