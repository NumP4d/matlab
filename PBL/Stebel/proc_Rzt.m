function [ R ] = proc_Rzt( proc );
% opór turbulentny zaworu w funkcji procentu sterowania przy za³o¿eniu V=3.46;%%[l/min]
%we1=[0 10,20,30,35,40,45,50,55,60,65,70,72,74,76,78,80,85,90,100]; % sterowanie w procentach
x=proc;
if proc<72
R=4.8231*x.^5-721.59*x.^4+41255*x.^3-9.5681e5*x.^2+1.059e7*x-1.5468e6;
elseif (proc>=72) && (proc<=78)
R=2.7464e6*x.^3-5.9127e8*x.^2+4.2506e10*x-1.0193e12;
else
R=-5.1492e5*x.^3+1.2894e8*x.^2-1.0237e10*x+2.606e11;
end
