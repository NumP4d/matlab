function [u_n, sum_e] = Controller(SP, yi, sum_e_in, k, Ti, Ts)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    e = SP - yi;
    sum_e = sum_e_in + Ts*e;
    % P controller
    %u_n = k * e;
    % PI controller
    u_n = k * (e + sum_e / Ti);
end

