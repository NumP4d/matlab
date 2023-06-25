function [Pi] = ControlValve(Pi, u, dt)
%CONTROLVALVE Summary of this function goes here
%   Detailed explanation goes here
    V=5.7667e-05; % [m3/s] 3.46[l/min] przep�yw ca�kowity
    %zmiany Rr 0 do 6.0000e+10 [Pa*s/m3]
    Tr=2.5; % [s] sta�a czasowa zaworu (dynamika przyrostu ci�nienia)

    % u percentage to Rr
    if u<72
        Rr = 4.8231*u.^5-721.59*u.^4+41255*u.^3-9.5681e5*u.^2+1.059e7*u-1.5468e6;
    elseif (u>=72) && (u<=78)
        Rr = 2.7464e6*u.^3-5.9127e8*u.^2+4.2506e10*u-1.0193e12;
    else
        Rr = -5.1492e5*u.^3+1.2894e8*u.^2-1.0237e10*u+2.606e11;
    end
    
    Pi = (-Pi/Tr + ((V)^2)*Rr/Tr)*dt + Pi;
end

