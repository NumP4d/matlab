function [bi_n, Pi_n] = RLS_Plant(fi, yi, bi, Pi, alpha)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here    
    Pi_n = 1 / alpha * (Pi - (Pi * fi * fi' * Pi) / (alpha + fi' * Pi * fi));
    ki_n = Pi_n * fi;
    bi_n = bi + ki_n * (yi - fi' * bi);
end