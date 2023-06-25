clear;
close all;
clc;

filename = 'wyniki_21_02_20_drugie_wiekszy_zakres.txt';

X = textread(filename);

% Zakres czasu 1: do 4490;
%X = X(1:4490, :);
% Drugi zakres 4491:end
X = X(4491:end, :);

time = X(:, 1);
auto = X(:, 3);

% Silownik1:
type = X(:, 4 + 11);
p = X(:, 5 + 11);
F = X(:, 6 + 11);
x = X(:, 7 + 11);
sp = X(:, 10 + 11);
u = X(:, 14 + 11);

sp_p = sp;
sp_p(auto == 1 & type ~= 0) = 0;
sp_p(auto == 0) = 0;
sp_F = sp;
sp_F(auto == 1 & type ~= 1) = 0;
sp_F(auto == 0) = 0;
sp_x = sp;
sp_x(auto == 1 & type ~= 2) = 0;
sp_x(auto == 0) = 0;

figure;
subplot(2, 1, 1);
plot(time, p, 'b');
hold on;
grid on;
ylabel('Pressure, mPa');
xlabel('time, s');

subplot(2, 1, 2);
stairs(time, u, 'b');
grid on;
hold on;
ylabel('Control value');
xlabel('time, s');

figure;
subplot(2, 1, 1);
plot(time, x, 'b');
hold on;
grid on;
ylabel('Actuator translation, mm');
xlabel('time, s');

subplot(2, 1, 2);
stairs(time, u, 'b');
grid on;
hold on
ylabel('Control value');
xlabel('time, s');

% Pierwszy skok (25 -> 30);
t1 = 387.4;
t2 = 449.6;
warunek = (time >= t1) & (time <= t2);

figure;
subplot(3, 1, 1);
plot(time(warunek), p(warunek), 'b');
hold on;
grid on;
ylabel('Pressure, mPa');
xlabel('time, s');

subplot(3, 1, 2);
plot(time(warunek), x(warunek), 'b');
hold on;
grid on;
ylabel('Actuator translation, mm');
xlabel('time, s');

subplot(3, 1, 3);
stairs(time(warunek), u(warunek), 'b');
grid on;
hold on
ylabel('Control value');
xlabel('time, s');

du = 5;

p_ust = 3.459;
p_pocz = 2.371;

k_wzm_p = (p_ust - p_pocz) / du
T_p = 30.8

x_ust = 64.25;
x_pocz = 45.77;

k_wzm_x = (x_ust - x_pocz) / du
T_x = 24.6

% Drugi skok (30 -> 35)
t1 = 449.6;
t2 = 608.2;
warunek = (time >= t1) & (time <= t2);

figure;
subplot(3, 1, 1);
plot(time(warunek), p(warunek), 'b');
hold on;
grid on;
ylabel('Pressure, mPa');
xlabel('time, s');

subplot(3, 1, 2);
plot(time(warunek), x(warunek), 'b');
hold on;
grid on;
ylabel('Actuator translation, mm');
xlabel('time, s');

subplot(3, 1, 3);
stairs(time(warunek), u(warunek), 'b');
grid on;
hold on
ylabel('Control value');
xlabel('time, s');

du = 5;

p_ust = 4.128;
p_pocz = 3.456;

k_wzm_p2 = (p_ust - p_pocz) / du
T_p2 = 22.2

x_ust = 76.74;
x_pocz = 64.25;

k_wzm_x2 = (x_ust - x_pocz) / du
T_x2 = 32.6

lambda = 0.7

kr_p = T_p ./ (k_wzm_p .* (lambda * T_p))
Ti_p = T_p

lamda = 0.7

kr_x = T_x ./ (k_wzm_x .* (lambda * T_x))
Ti_x = T_x