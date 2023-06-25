function [ c, ceq ] = ANC_nlinconst( x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %Ho_w = ANC_Ho_w(x);
    
    % minimum of 100 to 1000 Hz
    %J_w = 10 * log10(abs(1 + Ho_w(1:50)).^2);

    c(1) = ANC_PM_con(x);
    c(2) = ANC_AM_con(x);
    %c(3) = max(abs(roots([x(6) x(5) 1.0]))) - 0.95;    % abs from square roots <= 0.95 (max for stability of regulator is 1.0)
    c(3) = max(abs(roots([1.0, x(5), x(6)]))) - 0.95;
    %c(3) = ANC_MaxReduction_con(x);
    %c(4) = (x(9) == 0);
    %c(5) = max(abs(x / x(9))) - 100;
    %c(4) = ~(x(4) == 1);
    %c(4) = ANC_U_con(x);
    %c(5) = x(1) / x(9) - 50;
    %c(5) = max(abs(x / x(4))) - 200;
    c(4) = ANC_MinReduction_con(x);
    %c(6) = -min(J_w);
    %ceq = max(x / x(9)) - 1;
    ceq = [];

end

