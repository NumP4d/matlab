function [newU] = PolePlacementController(R,S,T,y,w,u) % R,S,T as 2 element vectors, y,u as full vector
if length(u) < 2
    newU = (T * w - (S(1) * y(end) + S(2) * y(end)) - R(2) * u(end)) / R(1);
else
    newU = (T * w - (S(1) * y(end) + S(2) * y(end-1)) - R(2) * u(end)) / R(1);
end