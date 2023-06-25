clear;
close all;
clc;

% Brak wzorcowania przyrządu
c = [0; 1];

% Charakterystyka przyrządu (nieznana, ale zadana)
b = [3, 200];

% Sigma stałe dla każdego x
%type = 'stale';
type = 'proporcjonalne';

% Ilość pomiarów
N = 10000;

xmin = 0;
xmax = 10;

% Sigma przyrządu:
sig = 3;
k = 0.1;

% Losujemy wartości próbek z rozkładu równomiernego [0; 10]
xw = xmin + rand(N, 1) * xmax;
% xmin = 0;
% n = 10;
% x_pu = xmin:(xmax / (n-1)):xmax;
% xw = xmin + round(rand(N, 1) * (n-1)) * (xmax / (n-1));
%xw = x_pu(round(rand(N, 1) * (n-1)));

yw = przyrz_pom2(xw, b, c, sig, k, type);

% % Przedziały ufności:
% pu = zeros(n, 1);
% %pu(1) = std(yw(xw <= 0.1));
% y_mean = zeros(n, 1);
% for i = 1:n
%     %pu(i) = std(yw((xw <= (xmax * 1.05 / (i-1))) & (xw >= (xmax * 0.95 / (i-1)))));
%     %y_mean(i) = mean(yw((xw <= (xmax * 1.05 / (i-1))) & (xw >= (xmax * 0.95 / (i-1)))));
%     pu(i) = std(yw( (xw >= (x_pu(i) - 0.1) & (xw <= (x_pu(i) + 0.1))) ));
%     y_mean(i) = mean(yw( (xw >= (x_pu(i) - 0.1) & (xw <= (x_pu(i) + 0.1))) ));
% end
% 
% pu = pu * 2;

figure;
subplot(2, 1, 1);
scatter(xw, yw, 'b.');
grid on;
hold on;
% plot(x_pu, y_mean + pu, 'k--');
% plot(x_pu, y_mean - pu, 'k--');
title(type);
xlabel('x');
ylabel('y');

% Procedura kalibracji:
[b_kal, c_kal] = kalibracja(xw, yw, type);

x = xmin:0.0001:xmax;
y = b_kal(1) + b_kal(2) * x;

plot(x, y, 'r', 'linewidth', 2);

% Testy kalibracji pomiarów:
N_test = 10000;
x_test = xmin + rand(N_test, 1) * xmax;

% c_kal = [-1.4843;
%           0.4967];
y_test = przyrz_pom2(x_test, b, c_kal, sig, k, type);

subplot(2, 1, 2);
scatter(x_test, y_test, 'b.');
hold on;
grid on;
plot(x, x, 'r', 'linewidth', 2);
xlabel('x');
ylabel('x*');
legend('pomiary', 'oczekiwana', 'location', 'best');
