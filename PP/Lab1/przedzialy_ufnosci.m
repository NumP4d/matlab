clear;
close all;
clc;

% Brak wzorcowania przyrządu
c = [0; 1];

% Charakterystyka przyrządu (nieznana, ale zadana)
b = [3, 2];

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

yw = przyrz_pom2(xw, b, c, sig, k, type);

figure;
subplot(2, 1, 1);
scatter(xw, yw, 'b.');
grid on;
hold on;
title(type);
xlabel('x');
ylabel('y');

% Procedura kalibracji:
[b_kal, c_kal] = kalibracja(xw, yw, type);

x = xmin:0.0001:xmax;
y = b_kal(1) + b_kal(2) * x;

plot(x, y, 'r', 'linewidth', 2);
legend('pomiary', 'dopasowana charakterystyka', 'location', 'best');

% Testy kalibracji pomiarów:
N_test = 10000;

n = 10;
x_pu = xmin:(xmax / (n-1)):xmax;
x_test = xmin + round(rand(N, 1) * (n-1)) * (xmax / (n-1));

y_test = przyrz_pom2(x_test, b, c_kal, sig, k, type);

poziom_ufnosci = 0.95;

% Przedziały ufności:
pu = zeros(n, 1);
y_mean = zeros(n, 1);
for i = 1:n
    warunek = (x_test >= (x_pu(i) - 0.1) & (x_test <= (x_pu(i) + 0.1)));
    pu(i) = std(y_test(warunek));
    y_mean(i) = mean(y_test(warunek));
    N_i = sum(warunek);
    tpk = tinv(1 - (1 - poziom_ufnosci) / 2, N_i - 2);
    pu(i) = pu(i) * tpk;
end

subplot(2, 1, 2);
scatter(x_test, y_test, 'b.');
hold on;
grid on;
plot(x, x, 'r', 'linewidth', 2);
plot(x_pu, y_mean + pu, 'k--');
plot(x_pu, y_mean - pu, 'k--');
xlabel('x');
ylabel('x*');
legend('pomiary', 'oczekiwana', 'location', 'best');
