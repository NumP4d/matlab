function [Ft] = Resistance(dxi)
%RESISTANCE Summary of this function goes here
%   Detailed explanation goes here
    Ft = 0;

    if (dxi > 0)
        Ft = -1;
    elseif (dxi < 0)
        Ft = 1;
    end
end

