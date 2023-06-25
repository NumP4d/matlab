function [u_n] = AdaptablePoleZerosPlacementController(u, y, w, bi, beta, Km, nR)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    R = bi(1:(nR+1))';
    S = bi((nR+2):end)';
    
    T = Km * [1, beta]; % Bm
    
%     w_f = w(end) * T(1) + w(end-1) * T(2);
%     y_f = y(end) * S(1) + y(end-1) * S(2);
%     err = w_f - y_f;
%     u_n = (err - R(2) * u(end) - R(3) * u(end-1)) / R(1)

    % Equation R u = -S y + T w
    u_n = (- FIR(S, y) + FIR(T, w) - FIR(R(2:end), u)) ./ R(1);

end