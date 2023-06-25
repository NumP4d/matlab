function [ y ] = ANC_OptimFun( x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % algorithm should maximize maximum noise reduction across all
    % frequencies, so minimize - max
    y = -max(ANC_Reduction(x));
    
    %J_w = ANC_Reduction(x);
    
    %y = -min(J_w(350:500));

end

