clear all;
close all;
u = fminsearch(@testowe,[2 2 2]);
x(1) = 6;
for i=1:1:3
    x(i+1) = 2*x(i) + u(i);
end
xK = x(4);
x = x(1:3); 

figure;
x = 0:0.1:2*pi;
plot(x, sin(x));
grid on;
