function [ c ] = ANC_PM_con( coefs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    tmp_Ho_w = ANC_Ho_w(coefs);

    PM = min(pi + angle(tmp_Ho_w(abs(abs(tmp_Ho_w) - 1) <= 0.05)));
    if (isempty(PM))
        c = pi;
    else
        c  = 30 / 180 * pi - PM;    % phase marign >= 30 deg
    end

end

