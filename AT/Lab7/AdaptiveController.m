function [u_n, sum_e, k] = AdaptiveController(SP, yi, sum_e_in, k, Ti, Ts)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    e = SP - yi;
    % overshoot
    if (e < 0.1 * SP)
        if (k > 0)
            k = k - 0.2;
        end
    elseif (e > 0.1 * SP)
        k = k + 0.02;
    end
    sum_e = sum_e_in + Ts*e;
    sum_e = 0;
    % P controller
    %u_n = k * e;
    % PI controller
    u_n = k * (e + sum_e / Ti);
end

