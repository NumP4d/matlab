clear;
close all;
clc;

x0 = 10;
x3 = 20;

%vj1 = 20;
vj1 = 20.0861
vj2 = 2;

t = [100, 100];

J = @(u) 2*x0 + u(1).^2 + 2*(x0+u(1)) + u(2).^2 + 2*(x0 + u(1) + u(2)) + u(3).^2;
J_ = @(u) J(u) + t(1) * 0.5 * (x0 + u(1) + u(2) + u(3) - vj1).^2 + t(2) * 0.5 * sum((-u + vj2) .* max(0, -u + vj2));

u_ = fminsearch(J_, [1, 1, 1])
x3_ = x0 + sum(u_)
wsk_jak = J_(u_)

%a = [ones(1, 3) .* vj2, vj1];
ri = [max(0, -u_ + vj2), x3_-vj1]

eps = norm(ri, 2)