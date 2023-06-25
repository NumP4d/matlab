function [R, S, T] = PolePlacement(num,den,alfa)
Ao = 1; % observer polynomial assumed for double inertia
Km = (1 + alfa)/sum(num);

%% solve linear equation system to get f1, g0, g1 (f0 is always 1)
b0 = num(1);
b1 = num(2);
a1 = den(1);
a2 = den(2);
linA = [1 b0 0;a1 b1 b0;a2 0 b1];
linB = [alfa - a1;-a2;0];
linX = linsolve(linA,linB);

%% compute the R,S,T controller param
F = [1, linX(1)]';
G = [linX(2),  linX(3)]';
R = F;
S = G;
T = Ao*Km;
end