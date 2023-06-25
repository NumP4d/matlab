clear;
close all;
clc;

%filename = 'wyniki_22_01_20.txt';

filename = 'pomiary_cisnienie_11_03_20.txt';

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
sp_F = sp;
sp_F(auto == 1 & type ~= 1) = 0;
sp_x = sp;
sp_x(auto == 1 & type ~= 2) = 0;

t_auto = time(auto == 1);
t_xlim = [t_auto(1), t_auto(end)];

t1 = 35.2;
t2 = 62.6;

figure;
%subplot(3, 1, 3);
plot(time(auto == 1), p(auto == 1), 'b');
hold on;
grid on;
plot(time(auto == 1), sp_p(auto == 1), 'r');
plot([t1-0.0001, t1+0.0001], [0, 6], 'k--');
plot([t2-0.0001, t2+0.0001], [0, 6], 'k--');
ylim([0, 6]);
xlim(t_xlim);
ylabel('Pressure, mPa');
xlabel('time, s');

%subplot(3, 1, 1);
figure;
plot(time(auto == 1), F(auto == 1), 'b');
hold on;
grid on;
plot(time(auto == 1), sp_F(auto == 1), 'r');
plot([t1-0.0001, t1+0.0001], [0, 120], 'k--');
plot([t2-0.0001, t2+0.0001], [0, 120], 'k--');
ylim([0, 120]);
xlim(t_xlim);
xlim(t_xlim);
ylabel('Force, kN');
xlabel('time, s');

%subplot(3, 1, 2);
figure;
plot(time(auto == 1), x(auto == 1), 'b');
hold on;
grid on;
plot(time(auto == 1), sp_x(auto == 1), 'r');
plot([t1-0.0001, t1+0.0001], [0, 5], 'k--');
plot([t2-0.0001, t2+0.0001], [0, 5], 'k--');
ylim([0, 5]);
xlim(t_xlim);
ylabel('Actuator translation, mm');
xlabel('time, s');

figure;
stairs(time(auto == 1), u(auto == 1), 'b');
grid on;
hold on;
plot([t1-0.0001, t1+0.0001], [0, 15], 'k--');
plot([t2-0.0001, t2+0.0001], [0, 15], 'k--');
ylim([0, 15]);
xlim(t_xlim);
ylabel('Control value');
xlabel('time, s');

figure;
%subplot(3, 1, 3);
plot(time(auto == 0), p(auto == 0), 'b');
grid on;
ylabel('Pressure, mPa');
xlabel('time, s');

%subplot(3, 1, 1);
figure;
plot(time(auto == 0), F(auto == 0), 'b');
grid on;
ylabel('Force, kN');
xlabel('time, s');

%subplot(3, 1, 2);
figure;
plot(time(auto == 0), x(auto == 0), 'b');
ylim([0, 5]);
xlim(t_xlim);
ylabel('Actuator translation, mm');
xlabel('time, s');

figure;
stairs(time(auto == 0), u(auto == 0), 'b');
grid on;
ylabel('Control value');
xlabel('time, s');