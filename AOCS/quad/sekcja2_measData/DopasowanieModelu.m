clear;
close all;
clc;

readMeasData;
close all;

accelNum = 5;

signal_u = extAccSig1;
signal_y = unsprungSprungAccSig(:, accelNum);

figure;
subplot(2, 1, 1)
plot(tVec, signal_y);
xlim([tVec(1), tVec(end)]);
ylabel('output acceleration');
subplot(2, 1, 2);
plot(tVec, signal_u);
xlim([tVec(1), tVec(end)]);
xlabel('time');
ylabel('input force');

czas_idx = (tVec >= 2.208) & (tVec <= 22.83);
u = signal_u(czas_idx);
y = signal_y(czas_idx);

u_offset = mean(signal_u(tVec >= 24.5));
y_offset = mean(signal_y(tVec >= 24.5));

u_raw = u;
y_raw = y;

u = u_raw - u_offset;
y = y_raw - y_offset;

czas = tVec(czas_idx);

figure
subplot(2, 1, 1);
plot(czas, y, 'b');
hold on;
grid on;
%plot(czas, y_raw - y_offset, 'b');
xlim([czas(1), czas(end)]);
ylabel('output acceleration');
subplot(2, 1, 2);
plot(czas, u, 'b');
hold on;
grid on;
%plot(czas, u_raw - u_offset, 'b');
xlim([czas(1), czas(end)]);
xlabel('time');
ylabel('input force');


% ARX model setting
nB = 1;
nA = 2;
% nB = 2;
% nA = 3;
delModel = 1;

% Initial for RLS algorithm
bi = zeros(1 + nB + nA, 1);
bi(1) = 1;
Pi = diag(100 * ones(length(bi), 1));
alpha = 1;

y_p = [];
bi_c = bi;

for i = 2:length(y)
    % Generate fi vector
    [fi] = GenerateFi(u(1:(i-1)), y(1:(i-1)), delModel, nB, nA);
    y_pi = ModelPlant(fi, bi);
    y_p = [y_p, y_pi];
    [bi, Pi] = RLS_Plant(fi, y(i), bi, Pi, alpha);
    % Save parameters
    bi_c = [bi_c, bi];
end

dopasowanie_modelu = 100 - sum((y(1001:end)'-y_p(1000:end)).^2) / sum(y(1001:end).^2) * 100;

disp(['Dopasowanie modelu: ', num2str(dopasowanie_modelu), '%']);

figure;
subplot(3, 1, 1);
plot(czas(2:end), y(2:end), 'b');
hold on;
grid on;
plot(czas(2:end), y_p, 'r');
legend('measurements', 'model');
ylabel('output acceleration');
xlim([czas(2), czas(end)]);
subplot(3, 1, 2);
plot(czas, u, 'b');
grid on;
xlim([czas(1), czas(end)]);
ylabel('input force');
subplot(3, 1, 3);
plot(czas, sum(bi_c));
grid on;
xlim([czas(2), czas(end)]);
ylabel('sum of parameters');
xlabel('time');

B = bi(1:(nB+1))
A = [1; bi((nB+2):end)]

zeros = roots(B);
poles = roots(A);

figure;
zplane(zeros, poles);

figure;
korelacjaWzajemna(u, y);

figure;
impulse(tf(B', A', 1/500));