clear;
close all;
clc;

filename = 'eksperyment_31_01_2020.txt';

X = textread(filename);

time = X(:, 1);
auto = X(:, 3);

% Silownik1:
type = X(:, 4);
p = X(:, 5);
F = X(:, 6);
x = X(:, 7);
sp = X(:, 10);
u = X(:, 14);

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

t_end1 = 1097;

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

zadany_skok = 95;

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


% Wyznaczamy wzmocnienie przykładowe
zakres = 50; % 50 MPa
% Dla 35 %
p_ust = 1.137 ./ zakres * 100; % MPa -> % zakresu
p_pop = 0.855 ./ zakres * 100; % MPa -> % zakresu
du = 5; % % zakresu

T1 = 12; % sekund

k_zaw1 = (p_ust - p_pop) ./ du

p_ust = 2.903 ./ zakres * 100; % MPa -> % zakresu
p_pop = 2.392 ./ zakres * 100; % MPa -> % zakresu
du = 5; % % zakresu

% Dla 70 %
T2 = 1.75; % sekundy

k_zaw2 = (p_ust - p_pop) ./ du


p_ust = 37 ./ zakres * 100; % MPa -> % zakresu
p_pop = 36.45 ./ zakres * 100; % MPa -> % zakresu
du = 5; % % zakresu

% Dla 70 %
T3 = 4.5; % sekundy

k_zaw3 = (p_ust - p_pop) ./ du

lambda = 0.9;
kr1 = T1 ./ (k_zaw1 .* (lambda * T1))
kr2 = T2 ./ (k_zaw2 .* (lambda * T2))
kr3 = T3 ./ (k_zaw3 .* (lambda * T3))