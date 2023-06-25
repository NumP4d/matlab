function [ c ] = ANC_MinReduction_con( coefs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % minimum Noise Reduction should be -4 dB (maximum noise amplifying
    % 4 dB)
    c = -min(ANC_Reduction(coefs)) - 15;

end

