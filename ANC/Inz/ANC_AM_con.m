function [ c ] = ANC_AM_con( coefs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here]

    tmp_Ho_w = ANC_Ho_w(coefs);

    AM = 20*log10(1 / abs(min(real(tmp_Ho_w(imag(tmp_Ho_w) <= 0.05)))));
    c = 3 - AM;     % amplitude margin should be more than 6 dB

end

