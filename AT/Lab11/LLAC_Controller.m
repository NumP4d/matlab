function [ui] = LLAC_Controller(w, y, u, q, bi, delModel, nB, nA, n_horizon)
    
    % Remember last control value
    u_last = u(end);
    
    % Make assumption of constant SP in future
    w_f = ones(n_horizon, 1) .* w(end);
    
    % Generate vector of future prediction y
    for i = 1:n_horizon
        % Generate fi vector
        [fi] = GenerateFi(u, y, delModel, nB, nA);

        % Make one-step prediction
        y_pi = ModelPlant(fi, bi);
        
        % Update output vector with prediction value
        y = [y, y_pi];
        % Update control vector with constant value
        u = [u, u_last];
    end
    
    % Calculate increment of ui
    d_ui = q' * (w_f - y((end - n_horizon + 1):end)');
    
    % Calculate ui
    ui = u_last + d_ui;
end

