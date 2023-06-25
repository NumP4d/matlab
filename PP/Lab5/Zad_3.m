clear;
close all;
clc;

% Parameters
A = 10;
odch = 0.05 * A;
N_diff = 1;
h = 1;
omega = 3 * 2 * pi / 200;

x = 0:h:200;
y = A * sin(omega * x);
noise = odch * randn(1, length(x));
y_noise = y + noise;

% Calculate differential vs ideal
dy_diff = diff(y_noise, N_diff) / h;
dy_ideal = A * omega * cos(omega * x);
dy_ideal = dy_ideal(2:end);

% Check linearity
dy_diff_sum = diff(y, N_diff) / h + diff(noise, N_diff) / h;
dy_diff_no_noise = diff(y, N_diff) / h;

figure;
subplot(2, 1, 1);
plot(x, y_noise);
grid on;
subplot(2, 1, 2);
plot(x(2:end), dy_diff, 'b');
hold on;
grid on;
plot(x(2:end), dy_diff_sum, 'r--');
plot(x(2:end), dy_diff_no_noise, 'g');
plot(x(2:end), dy_ideal, 'k--');
legend('diff', 'sum diff', 'diff no noise', 'ideal');

% Calculate SNR
y_SNR = var(y) ./ var(noise)
dy_SNR = var(dy_ideal) ./ var(dy_diff - dy_ideal)
decrease_quality = dy_SNR / y_SNR
