function [newX, newY] = plant(X,U,Tp,A,B,C) % sys is optional, goes by standard tf 

if nargin == 4 %if sys then go by standard state-space equation
    [A, B, C, D] = ssdata(A); % D coeficients currently unused
    dX = (A * X' + B * U) * Tp;
    newY = (C * X' + D);
    newX = dX' + X;
    return
end

%going by the given equations
dX(1) = (Tp * (A * X' + C * U));
dX(2) = (Tp * (B * X'));

newX (1) = X(1) + dX(1);
newX (2) = X(2) + dX(2);
newY =  newX(2);
end