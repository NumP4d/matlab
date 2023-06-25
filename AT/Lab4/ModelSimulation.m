function [t, u, y] = ModelSimulation(PI_kr, PI_Ti, b_params, T_sim, Ts)
    % Initial conditions
    ui =    0;
    y0 =    0;

    % Storage vectors
    u = ui;
    y = y0;
    
    % Controller sum init:
    sum_e = 0;
    
    % Time calculation
    t = 0:Ts:T_sim;
    
    SP = 0;
    
    for i = 1:(length(t)-1)
        % Plant simulation
        yi = b_params(1) * u(end) - b_params(2) * y(end);
        % Save output
        y = [y, yi];
        
        % Set point change:
        SP = 1;
        % Controller
        [ui, sum_e] = Controller(SP, yi, sum_e, PI_kr, PI_Ti, Ts);
        % Save CV
        u = [u, ui];
    end
end

