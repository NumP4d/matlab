function [Ft] = ConventionalDamper(vr_half, vnr, Ft)

    % Damper parameter
    %C = 10000; % Ns/m
    %C = 2500;
    C = 1185; % Ns/m
    
    % System equations for first order differentials
    Ft_n = C .* (vr_half(end) - vnr(end));
            
    % Update calculated values
    Ft = [Ft, Ft_n];
    
end