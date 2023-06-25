function [Pxi, Vt, yi] = Damper(Pxi, Pi, yi, dt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    Tt=0.5; % [s] sta�a czasowa t�umika
    St=0.0039; % [m2] powierzchnia t�umika
    ymax=0.003;  % [m]  maksymalny zakres y t�umika
    Vct=St*ymax; % [m3] ca�kowita pojemno�� t�umika
    
    Pxi = (Pi - Pxi) / Tt * dt;
    yi_n  = Pxi / (Pi + Pxi) * Vct / St;
    % Saturate y
    if (yi_n < 0)
        yi_n = 0;
    end
    if (yi_n > ymax)
        yi_n = ymax;
    end
    
    dy = (yi_n - yi) / dt;
    
    Vt = St * dy;

end

