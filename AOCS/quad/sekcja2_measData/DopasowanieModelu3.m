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
subplot(2, 1, 2);
plot(tVec, signal_u);

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
plot(czas, u, 'b');
hold on;
grid on;
plot(czas, u_raw - u_offset, 'r');
xlim([czas(1), czas(end)]);
subplot(2, 1, 2);
plot(czas, y, 'b');
hold on;
grid on;
plot(czas, y_raw - y_offset, 'r');
xlim([czas(1), czas(end)]);

u_fft = 20*log10(abs(fft(u)));
u_fft = u_fft(1:end/2);
y_fft = 20*log10(abs(fft(y)));
y_fft = y_fft(1:end/2);
f = 0:500/length(u):500;
f = f(1:end-1);
f = f(1:end/2);
figure;
subplot(2, 1, 1);
plot(f, y_fft, 'b');
grid on;
xlim([f(1), f(end)]);
subplot(2, 1, 2);
plot(f, u_fft, 'b');
grid on;
xlim([f(1), f(end)]);

figure;
model_nyquist = fft(y) ./ fft(u);
plot(real(model_nyquist), imag(model_nyquist), 'b');

freq_u = 1.68;
probki_na_okres = round(500 / freq_u);
ilosc_okresow = floor(length(u) / probki_na_okres);
max_i = ilosc_okresow * probki_na_okres;

nowe_u = zeros(1, probki_na_okres);
nowe_y = zeros(1, probki_na_okres);
for i = 0:(max_i-1)
    nowe_u(mod(i, probki_na_okres) + 1) = nowe_u(mod(i, probki_na_okres) + 1) + u(i + 1);
    nowe_y(mod(i, probki_na_okres) + 1) = nowe_y(mod(i, probki_na_okres) + 1) + y(i + 1);
end

figure;
subplot(2, 1, 1);
plot(czas(1:probki_na_okres), nowe_y);
grid on;
subplot(2, 1, 2);
plot(czas(1:probki_na_okres), nowe_u);
grid on;

model_nyquist = fft(nowe_y) ./ fft(nowe_u);

w = 0:pi/(probki_na_okres):pi;
w = w(1:(end-1));

NB = 16000;
NA = 1;

[B, A] = invfreqz(model_nyquist, w, NB, NA);
[h_n, w_n] = freqz(B, A, 16000);

figure;
plot(real(model_nyquist), imag(model_nyquist), 'b.');
hold on;
grid on;
plot(real(h_n), imag(h_n), 'r');

% Całkowanie sygnału
h = 1/500;
B_int = [1; 1] * h / 2;
A_int = [1; -1];

y_int = filter(B_int, A_int, y);
y_int_int = filter(B_int, A_int, y_int);

y_int2 = zeros(size(y));

for i = 2:length(y)
    y_int2(i) = y_int2(i-1) + (y(i) + y(i-1)) * h / 2;
end

% ARX model setting
% nB = 29;
% nA = 30;
nB = 1;
nA = 2;
% nB = 0;
% nA = 1;
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
xlim([czas(2), czas(end)]);
subplot(3, 1, 2);
plot(czas, u, 'b');
grid on;
xlim([czas(1), czas(end)]);
subplot(3, 1, 3);
plot(czas, sum(bi_c));
grid on;
xlim([czas(2), czas(end)]);
xlabel('czas, s');

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

y_p = [];
for i = 2:length(signal_y)
    % Generate fi vector
    [fi] = GenerateFi(signal_u(1:(i-1)) - u_offset, signal_y(1:(i-1)) - y_offset, delModel, nB, nA);
    y_pi = ModelPlant(fi, bi);
    y_p = [y_p, y_pi];
end

figure;
plot(tVec(2:end), signal_y(2:end) - y_offset, 'b');
hold on;
grid on;
plot(tVec(2:end), y_p, 'r');