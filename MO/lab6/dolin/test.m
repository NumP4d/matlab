u = fminsearch(@wsk_jak,[0 0 0 0 0]);
x(1) = 17;
for i=1:1:5
    x(i+1) = 0.9*x(i) + u(i);
end
xN = x(6);
x = x(1:5);
% r1 = (sum((x-21).*max(x-21, 0)))
r2 = 0.5*(xN-20);
% R3 = sum((-u).*max(-u, 0))
% R4 = sum((-x).*max(-x, 0))
for i=1:1:5
    r1(i) = max(x(i)-21, 0);
    r3(i) = max(-u(i), 0);
    r4(i) = max(-x(i), 0);
end
r1
r2
r3
r4