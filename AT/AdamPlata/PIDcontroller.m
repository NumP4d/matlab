function [u, ui] = PIDcontroller(e,ep,ui,T,T0,K) %error, previous error, previous integral part, FOPDT stats
    %%CHR 20% servo PI tuning
    k = 0.6*T/(K*T0); %controller gain 
    Ti = T; %PID integral time constant
    Td = 0; %PID derivative time constant

    up = e;
    ui = ui + e/Ti;
    ud = (ep - e) * Td;
    
    u = k*(up + ui + ud);
      
    %% FOPDT of the defualt tf 
    %20.55 T
    %6.15 T0
    %5 K
end