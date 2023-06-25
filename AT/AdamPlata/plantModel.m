function [y] = plantModel(fi, bi) % fi vector, parameters from rls
    y = fi' * bi; % predicted output
end
