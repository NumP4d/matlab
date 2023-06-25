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

order = 3;
framelen = 71;

[b, g] = sgolay(order,framelen);
% First column for normal filtering:
y_sg = sgolaydiff(y_noise,g(:, 1));
% 2 column for diff:
dy_sg = sgolaydiff(y_noise,g(:, 2));

x_sg = x((1 + (framelen - 1) / 2):(end - (framelen - 1) / 2));
dy_ideal_sg = dy_ideal((1 + (framelen - 1) / 2):(end - (framelen - 1) / 2));

y_sg = y_sg((1 + (framelen - 1) / 2):(end - (framelen - 1) / 2));
dy_sg = dy_sg((1 + (framelen - 1) / 2):(end - (framelen - 1) / 2));

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

figure;
subplot(2, 1, 1);
plot(x, y_noise, 'b');
hold on;
grid on;
plot(x_sg, y_sg, 'r');
legend('signal', 'sgolay');
xlim([x(1 + (framelen - 1) / 2), x(end - (framelen - 1) / 2)]);
subplot(2, 1, 2);
plot(x(2:end), dy_diff, 'b');
hold on;
grid on;
plot(x_sg, dy_sg, 'r');
legend('diff', 'diff sgolay');
xlim([x(1 + (framelen - 1) / 2), x(end - (framelen - 1) / 2)]);

% Calculate SNR for diff
y_SNR = var(y) ./ var(noise)
dy_SNR = var(dy_ideal) ./ var(dy_diff - dy_ideal)
decrease_quality = dy_SNR / y_SNR
% Calculate SNR for SGolay 
dy_sg_SNR = var(dy_ideal_sg) ./ var(dy_sg(1:end-1)' - dy_ideal_sg)
decrease_quality_sg = dy_sg_SNR / y_SNR
