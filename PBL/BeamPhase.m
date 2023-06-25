function [phase] = BeamPhase(Fni, phase)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    hist = 5;

    switch(phase)
        case 1
            if (Fni > 40)
                phase = 2;
            end
        case 2
            if (Fni < (40 - hist))
                phase = 1;
            end
            if (Fni > 130)
                phase = 3;
            end
        case 3
            if (Fni < (130 - hist))
                phase = 2;
            end
            if (Fni > 170)
                phase = 4;
            end
        case 4
            if (Fni > (170 + hist))
                phase = 5;
            end
              phase = 5;
        case 5
    end
end

