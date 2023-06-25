close all;
clear all;
clc;

N = 10;

eps = 0.001;
max_it = 100;

a1 = 1;
a2 = 0;

x = 1:N;
y = a1 * x + a2 + randn(1, N) / 10;

% Adding fat errors
y(1) = y(1) + 10;
%y(2) = 2;
y(9) = 0;
y(10) = 0;

y0 = y;

figure;
plot(x, y0, '*');
hold on;
grid on;

X = [ones(1, N);
     x]';
 
% Metoda najmniejszej mediany
% Funkcja do minimalizacji
fun_min_med = @(b, x, y) (median((y - b(1) - b(2) .* x).^2));
 
x = x';
y = y';

b0 = [1, 1];

bin = fminsearch(fun_min_med, b0, [], x, y);

y_p = bin(1) + bin(2) .* x;

plot(x, y_p, 'k--')
hold on;
plot(x, a1 * x + a2, 'r');

% Metoda najmniejszych kwadratów
P = polyfit(x, y, 1);
plot(x, P(1) * x + P(2), 'b');

legend('dane', 'fminsearch', 'idealna', 'polyfit')