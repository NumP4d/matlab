clear;
close all;
clc;

filename = 'wyniki_22_01_20.txt';

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

t_auto = time(auto == 1);
t_xlim = [time(1), time(end)];

t1 = 35.2;
t2 = 62.6;
t3 = t_auto(end);

figure;
plot(time, p, 'b');
hold on;
grid on;
plot(time, sp_p, 'r');
plot([t1-0.0001, t1+0.0001], [0, 8], 'k--');
plot([t2-0.0001, t2+0.0001], [0, 8], 'k--');
plot([t3-0.0001, t3+0.0001], [0, 8], 'k--');
ylim([0, 8]);
xlim(t_xlim);
ylabel('Pressure, mPa');
xlabel('time, s');

%subplot(3, 1, 1);
figure;
plot(time, F, 'b');
hold on;
grid on;
plot(time, sp_F, 'r');
plot([t1-0.0001, t1+0.0001], [0, 150], 'k--');
plot([t2-0.0001, t2+0.0001], [0, 150], 'k--');
plot([t3-0.0001, t3+0.0001], [0, 150], 'k--');
ylim([0, 150]);
xlim(t_xlim);
xlim(t_xlim);
ylabel('Force, kN');
xlabel('time, s');

%subplot(3, 1, 2);
figure;
plot(time, x, 'b');
hold on;
grid on;
plot(time, sp_x, 'r');
plot([t1-0.0001, t1+0.0001], [0, 7], 'k--');
plot([t2-0.0001, t2+0.0001], [0, 7], 'k--');
plot([t3-0.0001, t3+0.0001], [0, 7], 'k--');
ylim([0, 7]);
xlim(t_xlim);
ylabel('Actuator translation, mm');
xlabel('time, s');

figure;
stairs(time, u, 'b');
grid on;
hold on;
plot([t1-0.0001, t1+0.0001], [0, 20], 'k--');
plot([t2-0.0001, t2+0.0001], [0, 20], 'k--');
plot([t3-0.0001, t3+0.0001], [0, 20], 'k--');
ylim([0, 20]);
xlim(t_xlim);
ylabel('Control value');
xlabel('time, s');
