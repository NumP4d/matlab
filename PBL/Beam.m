function [Fni] = Beam(Fni, xi, phase, dt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % Scale from meters to milimeters
    %xi = xi * 10^(3);
    
    % Filtration inertia T:
    T = 0.5;
    
    if (xi < 0)
        xi = 0;
    end

    switch(phase)
        case 1
            Fni_beam = 37.973 * xi;
        case 2
            Fni_beam = 19.029 * xi + 21.296;
        case 3
            Fni_beam = 13.841 * xi + 50.869;
        case 4
            Fni_beam = -5.9 * xi + 220.96; 
        case 5
            Fni_beam = -73.267 * xi + 832.8;
    end
    
    % Filtration of Fni
    Fni = 1 / T * (Fni_beam - Fni) * dt + Fni;
    
    % Saturation below 0
    if (Fni < 0)
        Fni = 0;
    end
end

