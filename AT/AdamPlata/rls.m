function [bNext,PNext]=rls(fi,yNext,P,b,alfa) % input, output, previous P matrix, previous estimator
    PNext = (P - ( (P*(fi*fi')*P) / (alfa + fi'*P*fi) ) ) / alfa; % compute the P matrix in current iteration
    kNext = PNext * fi; % compute the gain vector k in current iteration
    bNext = b + kNext * (yNext - fi'*b); % estimate the parameters in current iteration
end

function [bi_n, Pi_n] = RLS_Plant(fi, yi, bi, Pi, alpha)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    Pi_n = 1 / alpha * (Pi - (Pi * fi * fi' * Pi) / (alpha + fi' * Pi * fi));
    ki_n = Pi_n * fi;
    bi_n = bi + ki_n * (yi - fi' * bi);
end