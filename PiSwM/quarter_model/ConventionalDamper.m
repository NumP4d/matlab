function [Ft] = ConventionalDamper(C, vr, vnr)

    % System equations for first order differentials
    Ft = C .* (vr - vnr);
end