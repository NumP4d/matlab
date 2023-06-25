function [u_n] = AdaptiveController(u, y, SP, bi, delModel, nB, nA)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    % Generate fi vector
    [fi] = GenerateFi(u, y_c, delModel, nB, nA);
end

