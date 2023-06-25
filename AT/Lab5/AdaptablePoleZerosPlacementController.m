function [u_n] = AdaptablePoleZerosPlacementController(u, y, w, bi, beta, Km, nR)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    R = bi(1:(nR+1))';
    S = bi((nR+2):end)';
    
    T = Km * [1, beta]; % Bm
 
    % Equation R u = -S y + T w
    u_n = (- FIR(S, y) + FIR(T, w) - FIR(R(2:end), u)) ./ R(1);

end