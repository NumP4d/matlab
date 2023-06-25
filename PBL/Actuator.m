function [xi] = Actuator(xi, Pi, Ft, Fn, dt)
%ACTUATOR Summary of this function goes here
%   Detailed explanation goes here
    Ss=0.02;  % [m2] powierzchnia t�oka
    Rw=50000000;  % [Pa*s/m3] op�r w�y do si�ownika
    Cs=1/100000; % wsp�czynnik sztywno�ci spr�yny si�ownika [N/m]

    % Scale Pi from MPa to Pa
    Pi = Pi * 10^(6);
    % Scale F to N from kN
    Fn = Fn * 10^(3);
    Ft = Ft * 10^(3);
    
    Fs = Pi * Ss;

    xi_n = ((-xi + Cs*(Fs + Ft - Fn)) / (Cs*Rw*(Ss^2))) * dt + xi;
    if (xi_n < 0)
        xi_n = 0;
    end
    xi = xi_n;
end

