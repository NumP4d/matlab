function [Fni, phase, xryg, xi_beam] = Construction(Fni, xi, xryg, phase)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % Maximumum distance (mm) that construction is pushing up
    xryg_max = 6;

    % Scale from meters to milimeters
    xi = xi * 10^(3);
    
    hist = 1;

    switch(phase)
        case 1
            xi_beam = xi;
            if (Fni > 100)
                phase = 2;
                xryg = xi;
            end
        case 2
            Fni = 100;
            xi_beam = xryg;
            if (xi > xryg + xryg_max)
                phase = 3;
            end
            if (xi < (xryg - hist))
                phase = 1;
            end
        case 3
            xi_beam = xi - 6;
            if (xi < (xryg + xryg_max - hist))
                phase = 2;
            end
    end
    
end

