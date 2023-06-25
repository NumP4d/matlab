clear all;
close all;
clc;

m = 5; % stopien

f = 2 * m + 1; % szerokosc okna

t = 0:0.1:2*pi;

x_ideal = sin(2*t);
x = x_ideal + 0.2 * randn(size(t));

figure;
plot(t, x);

order = 7;
framelen = 51;

y = sgolayfilt(x,order,framelen);

hold on;
grid on;
plot(t, y, 'r');

plot(t, x_ideal, 'g');

xlim([t(1), t(end)]);