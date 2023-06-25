clear;
close all;
clc;

filename = 'wyniki_13_02_20_wiekszy_zakres.txt';

X = textread(filename);

time = X(:, 1);
auto = X(:, 3);

% Silownik1:
type = X(:, 4 + 11);
p = X(:, 5 + 11) * 20;
F = X(:, 6 + 11) * 20;
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

t_xlim = [time(1), time(end)];

t_end1 = 478.4;

p1 = p(time <= t_end1);
p2 = p(time > t_end1);
u1 = u(time <= t_end1);
u2 = u(time > t_end1);

t1 = time(time <= t_end1);
t2 = time(time > t_end1);

t_xlim1 = [time(1), t_end1];
t_xlim2 = [t_end1+0.2, time(end)];

figure;
subplot(2, 1, 1);
plot(t1, p1, 'b');
hold on;
grid on;
xlim(t_xlim1);
ylabel('Pressure, mPa');
xlabel('time, s');

subplot(2, 1, 2);
stairs(t1, u1, 'b');
grid on;
hold on;
xlim(t_xlim1);
ylabel('Control value');
xlabel('time, s');

figure;
subplot(2, 1, 1);
plot(t2, p2, 'b');
hold on;
grid on;
xlim(t_xlim2);
ylabel('Pressure, mPa');
xlabel('time, s');

subplot(2, 1, 2);
stairs(t2, u2, 'b');
grid on;
hold on;
xlim(t_xlim2);
ylabel('Control value');
xlabel('time, s');

zadany_skok = 40;

u_zad = u1(u1 == zadany_skok);
t_zad = t1(u1 == zadany_skok);
p_zad = p1(u1 == zadany_skok);

figure;
subplot(2, 1, 1);
plot(t_zad, p_zad, 'b');
hold on;
grid on;
%xlim(t_xlim2);
ylabel('Pressure, mPa');
xlabel('time, s');

subplot(2, 1, 2);
stairs(t_zad, u_zad, 'b');
grid on;
hold on;
%xlim(t_xlim2);
ylabel('Control value');
xlabel('time, s');

% Dla skoku 40:
zakres = 50; % 50 MPa
% Dla 35 %
p_ust = 0.773 * 20 ./ zakres * 100; % MPa -> % zakresu
p_pop = 0.473 * 20 ./ zakres * 100; % MPa -> % zakresu
du = 10; % % zakresu

T1 = 0.8; % sekund

k_zaw1 = (p_ust - p_pop) ./ du

lambda = 0.5;
kr1 = T1 ./ (k_zaw1 .* (lambda * T1))
% kr2 = T2 ./ (k_zaw2 .* (lambda * T2))
% kr3 = T3 ./ (k_zaw3 .* (lambda * T3))