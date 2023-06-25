function [u_n] = RelayController(SP, yi, B)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    e = SP - yi;

    if (e > 0)
        u_n = B;
    elseif (e < 0)
        u_n = -B;
    else
        u_n = 0;
    end
end

