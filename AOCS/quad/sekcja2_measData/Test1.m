    clear all;
close all;
clc;

readMeasData;
close all;

accelNum = 5;

signal_u = extAccSig1;
signal_y = unsprungSprungAccSig(:, 5);

% signal_u = unsprungSprungAccSig(:, accelNum);
% signal_y = unsprungSprungAccSig(:, 7);

figure;
subplot(2, 1, 1)
plot(tVec, signal_y);
subplot(2, 1, 2);
plot(tVec, signal_u);

czas_idx = (tVec >= 2.208) & (tVec <= 22.83);
%czas_idx = (tVec >= 0.58) & (tVec <= 13.02);
%czas_idx = tVec > -1;
u = signal_u(czas_idx);
y = signal_y(czas_idx);

 u_offset = mean(signal_u(tVec >= 24.5));
 y_offset = mean(signal_y(tVec >= 24.5));

% u_offset = mean(signal_u(tVec >= 13.67));
% y_offset = mean(signal_y(tVec >= 13.67));

[Bh, Ah] = butter(6, 1/250, 'high');
[Bl, Al] = butter(6, 249/250, 'low');

u_raw = u;
y_raw = y;

u = filtfilt(Bh, Ah, u);
u = filtfilt(Bl, Al, u);
y = filtfilt(Bh, Ah, y);
y = filtfilt(Bl, Al, y);

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
% pwelch is better for calculating fft
% u_fft = 20*log10(abs(fft(u)));
% freq = 0:(sampleFreq/length(u)):sampleFreq;
% freq = freq(1:end-1);
% freq = freq(1:end/2);
% u_fft = u_fft(1:end/2);
% plot(freq, u_fft);
plot(czas, y, 'b');
hold on;
grid on;
plot(czas, y_raw - y_offset, 'r');
xlim([czas(1), czas(end)]);

% N_fir = 1024;
% 
% nA = 300;
% nB = 299;
% nk = 1;
% 
% dane_ident = iddata(y, u, 1/sampleFreq);
% model = arx(dane_ident, [nA, nB, nk])

% ARX model setting
% nB = 29;
% nA = 30;
% nB = 4;
% nA = 5;
nB = 0;
nA = 1;
delModel = 1;

% Initial for RLS algorithm
bi = zeros(1 + nB + nA, 1);
%bi = zeros(1 + nB + nA + 1, 1);
bi(1) = 1;
Pi = diag(100 * ones(length(bi), 1));
alpha = 1;

y_p = [];
bi_c = bi;

for i = 2:length(y)
    % Generate fi vector
    [fi] = GenerateFi(u(1:(i-1)), y(1:(i-1)), delModel, nB, nA);
%     % Add bias to fi
%     fi = [fi; 1];
    y_pi = ModelPlant(fi, bi);
    y_p = [y_p, y_pi];
    [bi, Pi] = RLS_Plant(fi, y(i), bi, Pi, alpha);
    % Save parameters
    bi_c = [bi_c, bi];
end

MSE = 100 - sum((y(1001:end)'-y_p(1000:end)).^2) / sum(y(1001:end).^2) * 100

figure;
subplot(3, 1, 1);
plot(czas(2:end), y(2:end), 'b');
hold on;
grid on;
%plot(czas(2:end), y(2:end), 'b.');
plot(czas(2:end), y_p, 'r');
%plot(czas(2:end), y_p, 'r.');
%plot(y_p .* 0 + bi(end), 'k--');
subplot(3, 1, 2);
plot(u, 'b');
grid on;
hold on
plot(y, 'r--');
subplot(3, 1, 3);
plot(sum(bi_c));

figure;
B = bi(1:(nB+1));
A = [1; bi((nB+2):end-1)];
bias = bi(end);

zeros = roots(B);
poles = roots(A);

figure;
zplane(zeros, poles);

korelacjaWzajemna(u, y);

figure;
%sys = tf(B, A, 1/500);
impulse(tf(B', A', 1/500));
% impulse(sys);