function [ J_w ] = ANC_Reduction( coefs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    Ho_w = ANC_Ho_w(coefs);
    
    % minimum of 100 to 1000 Hz
    J_w = 10 * log10(abs(1 + Ho_w).^2);

end

