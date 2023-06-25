function [bi_n, Pi_n] = RLS_Plant(fi, yi, bi, Pi, alpha)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    Pi_n = 1 / alpha * (Pi - (Pi * fi * fi' * Pi) / (alpha + fi' * Pi * fi));
    ki_n = Pi_n * fi;
    bi_n = bi + ki_n * (yi - fi' * bi);
%     disp(ki_n);
      %Pi_n = yi - fi' * bi;
      %ki_n = 0.1 * [-1; -1; -1; -1];
      %bi_n = bi + ki_n * (yi - fi' * bi);
     % bi_n = bi + ki_n * (Pi_n - Pi);
     %ki_n = 0.002;
     %bi_n = bi + ki_n * fi * (yi - fi' * bi);
end

