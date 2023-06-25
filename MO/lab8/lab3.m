syms x y u

fun = @(x, y) 15*x+4*y;

eqn1 = 15 + 3*u*(x-5)^3 >= 0;
eqn2 = y + (x-5)^3 <= 0;
% 
% eqn1 = -2*x + 2*u*x + 4 == 0;
% eqn2 = -2*y + 2*u*y + 6 == 0;
% eqn3 = u == 0;

S = solve(eqn1, eqn2, eqn3, 'ReturnConditions', true)
% 
% S.x
% S.y
% S.u
% 
% eqn1 = -2*x + 2*u*x + 4 == 0;
% eqn2 = -2*y + 2*u*y + 6 == 0;
% eqn3 = x^2 + y^2 - 52 == 0;
% 
% S = solve(eqn1, eqn2, eqn3, 'ReturnConditions', true)
% 
% S.x
% S.y
% S.u
% 
% eqn1 = 15 + 3*u*(x-5)^2 == 0;
% eqn2 = y == 0;
% eqn3 = u == 0;
% 
% S = solve(eqn1, eqn2, eqn3, 'ReturnConditions', true)
% 
% S.x
% S.y
% S.u
% 
% %f(S.x, S.y)
% 
% eqn1 = x == 0;
% eqn2 = 4 + u == 0;
% eqn3 = u == 0;
% 
% S = solve(eqn1, eqn2, eqn3, 'ReturnConditions', true)
% 
% S.x
% S.y
% S.u
% 
% %f(S.x, S.y)

% eqn1 = 15 + 3*u*(x-5)^2 == 0;
% eqn2 = y == 0;
% eqn3 = y + (x-5)^3 == 0;
% 
% S = solve(eqn1, eqn2, eqn3, 'ReturnConditions', true)
% 
S.x
S.y
S.u