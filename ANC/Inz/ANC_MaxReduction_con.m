function [ c ] = ANC_MaxReduction_con( coefs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    % minimum of 200 to 800 Hz
    J_w = ANC_Reduction(coefs);

    % maximum Noise reduction should be 20 / 25 dB at all spectrum
    c = max(J_w(60:end)) - 25;

end

