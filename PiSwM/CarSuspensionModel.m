function [xr_half, fi, xnr_1, xnr_2, vr_half, wi, vnr_1, vnr_2] = CarSuspensionModel(x0_1, x0_2, Ft_1, Ft_2, xr_half, fi, xnr_1, xnr_2, vr_half, wi, vnr_1, vnr_2, Ts)

    % Car parameters
    mr_half = 580;  % kg
    J_half  = 1039; % kgm^2
    l1      = 0.99; % m
    l2      = 1.81; % m
    mnr_1   = 60;   % kg
    kr_1    = 15;   % kN/m
    knr_1   = 200;  % kN/m
    mnr_2   = 60;   % kg
    kr_2    = 15;   % kN/m
    knr_2   = 200;  % kN/m
    g       = 9.81; % m/s^2
   
    % System equations from second order differentials
    vr_half_n = ( mr_half .* g                                          ...
                - Ft_1(end)                                             ...
                - Ft_2(end)                                             ...
                - kr_1 .* (xr_half(end) + fi(end) * l1 - xnr_1(end))    ...
                - kr_2 .* (xr_half(end) - fi(end) * l2 - xnr_2(end))    ...
                ) ./ mr_half                                            ...
                .* Ts                                                   ...
                + vr_half(end);
    
    wi_n      = ( Ft_2(end) .* l2                                       ...
                - Ft_1(end) .* l1                                       ...
                + kr_2 .* (xr_half(end) - fi(end) .* l2 - xnr_2(end)) .* l2   ...
                - kr_1 .* (xr_half(end) + fi(end) .* l1 - xnr_1(end)) .* l1  ...
                ) ./ J_half                                             ...
                .* Ts                                                   ...
                + wi(end);
                    
    vnr_1_n   = (mnr_1 .* g                                             ...
                + Ft_1(end)                                             ...
                - knr_1 .* (xnr_1(end) - x0_1(end))                     ...
                + kr_1 .* (xr_half(end) + fi(end) .* l1 - xnr_1(end))   ...
                ) ./ mnr_1                                              ...
                .* Ts                                                   ...
                + vnr_1(end);
      
    vnr_2_n   = (mnr_2 .* g                                             ...
                + Ft_2(end)                                             ...
                - knr_2 .* (xnr_2(end) - x0_2(end))                     ...
                + kr_2 .* (xr_half(end) - fi(end) .* l2 - xnr_2(end))   ...
                ) ./ mnr_2                                              ...
                .* Ts                                                   ...
                + vnr_2(end);
            
    % Differential equations for v -> x
    xr_half_n   = vr_half(end)  .* Ts + xr_half(end);
    fi_n        = wi(end)       .* Ts + fi(end);
    xnr_1_n     = vnr_1(end)    .* Ts + xnr_1(end);
    xnr_2_n     = vnr_2(end)    .* Ts + xnr_2(end);
            
    % Update calculated values
    vr_half = [vr_half, vr_half_n];
    wi      = [wi,      wi_n     ];
    vnr_1   = [vnr_1,   vnr_1_n  ];
    vnr_2   = [vnr_2,   vnr_2_n  ];
    
    xr_half = [xr_half, xr_half_n];
    fi      = [fi,      fi_n     ];
    xnr_1   = [xnr_1,   xnr_1_n  ];
    xnr_2   = [xnr_2,   xnr_2_n  ];
    
end

