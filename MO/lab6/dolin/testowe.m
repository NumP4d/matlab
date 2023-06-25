function [ wynik ] = testowe( u )
x = zeros(1,4);
x(1) = 6;
for i=1:1:3
    x(i+1) = 2*x(i) + u(i);
end
xK = x(4);
x = x(1:3);
wynik = sum(u + x) + 0.5*(xK - 200)^2 +sum((-u + 2).*max(0,-u + 2));
end