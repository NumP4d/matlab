clear;
close all;
clc;

% Signal parameters
freq = 200;
freq_h = 1500;
offset = 200;
Fs = 8000;

% Signal
t = 0:1/Fs:2;
[Bnoise, Anoise] = butter(8, 1500/4000, 'high');
high_freq_noise = filter(Bnoise, Anoise, 100*randn(size(t)));
x = 10 * sin(2*pi*freq*t) + offset + 25 * sin(2*pi*freq_h*t); %+ high_freq_noise;

% Antialiasing butterworth low-pass
% 2-nd order sallen-key
[B11, A11] = butter(2, 1533/4000, 'low');
sys11 = tf(B11, A11, 1/Fs);
[B12, A12] = butter(1, 1591/4000, 'low');
sys12 = tf(B12, A12, 1/Fs);
% [B11, A11] = butter(2, 1533/4000, 'low');
% sys11 = tf(B11, A11, 1/Fs);
% sys12 = 1;
[B13, A13] = butter(1, 1.57/4000, 'high');
sys13 = tf(B13, A13, 1/Fs);
sys_an = sys11 * sys12 * sys13;
B_an = cell2mat(sys_an.Numerator);
A_an = cell2mat(sys_an.Denominator);
A_an = A_an(A_an ~= 0);
[h_an, w] = freqz(B_an, A_an, 4000);

% Frequency scailing
freq = w / pi * 4000;

% Plot analog filter
figure;
semilogx(freq, 20*log10(abs(h_an)));
grid on;
xlim([0, 4000]);
xlabel('Frequency, Hz');
ylabel('Magnitude, dB');

% Butterworth high-pass filter
[B1, A1] = butter(2, 20/4000, 'high');
sys1 = tf(B1, A1, 1/Fs);
[h1, w] = freqz(B1, A1, 4000);

% Notch filter for 50 Hz
wo = 50/(Fs/2);    % this is for 50 Hz
%wo = 500/(Fs/2);        % now it is for 500 Hz
%bw = wo/35;
bw = wo/5;
%bw = (55 - 45) / 50;
[B2, A2] = iirnotch(wo,bw);
B2 = 1;
A2 = 1;
sys2 = tf(B2, A2, 1/Fs);
[h2, ~] = freqz(B2, A2, 4000);

% FIR low-pass filter
f = [0, 500, 500, 4000] / 4000;
m = [1, 1, 0, 0];
N = 31;
B3 = fir2(N, f, m);
sys3 = tf(B3, 1, 1/Fs);
[h3, ~] = freqz(B3, 1, 4000);

% N_movmean = 8;
% B3 = ones(1, N_movmean) / N_movmean;

sys3 = tf(B3, 1, 1/Fs);
[h3, ~] = freqz(B3, 1, 4000);

% Frequency scailing
freq = w / pi * 4000;

% Plot filters
figure;
subplot(2, 1, 1);
semilogx(freq, 20*log10(abs(h1)));
grid on;
xlim([0, 4000]);
xlabel('Częstotliwość, Hz');
ylabel('Wzmocnienie, dB');
subplot(2, 1, 2);
semilogx(freq, angle(h1) * 180 / pi);
grid on;
xlim([0, 4000]);
xlabel('Częstotliwość, Hz');
ylabel('Przesunięcie fazowe, deg');

figure;
subplot(2, 1, 1);
semilogx(freq, 20*log10(abs(h2)));
grid on;
xlim([0, 4000]);
xlabel('Częstotliwość, Hz');
ylabel('Wzmocnienie, dB');
subplot(2, 1, 2);
semilogx(freq, angle(h2) * 180 / pi);
grid on;
xlim([0, 4000]);
xlabel('Częstotliwość, Hz');
ylabel('Przesunięcie fazowe, deg');


figure;
subplot(2, 1, 1);
semilogx(freq, 20*log10(abs(h3)));
grid on;
xlim([0, 4000]);
xlabel('Częstotliwość, Hz');
ylabel('Wzmocnienie, dB');
subplot(2, 1, 2);
semilogx(freq, angle(h3) * 180 / pi);
grid on;
xlim([0, 4000]);
xlabel('Częstotliwość, Hz');
ylabel('Przesunięcie fazowe, deg');


% Filter combination
sys = sys1 * sys2 * sys3 * sys_an;
%sys = sys1 * sys2 * sys3;

B = cell2mat(sys.Numerator);
A = cell2mat(sys.Denominator);
A = A(A ~= 0);
[h, ~] = freqz(B, A, 4000);

% Plot combination of filters
figure;
subplot(2, 1, 1);
semilogx(freq, 20*log10(abs(h)));
grid on;
hold on;
semilogx(freq, freq.*0 -3, 'r--');
semilogx(freq, freq.*0 -50, 'r--');
xlim([0, 4000]);
xlabel('Częstotliwość, Hz');
ylabel('Wzmocnienie, dB');
ylim([-150, 10]);
subplot(2, 1, 2);
semilogx(freq, angle(h) * 180 / pi);
grid on;
xlim([0, 4000]);
xlabel('Częstotliwość, Hz');
ylabel('Przesunięcie fazowe, deg');

% Filter signal
y1 = filter(B1, A1, x);
y2 = filter(B2, A2, y1);
%y3 = filter(B3, 1, y2);
y3 = filter(B, A, x);

% Decimated signals
decimation = 4;
y4 = y3(1:decimation:end);

% Plot signal
figure;
plot(t, x, 'b');
grid on;
hold on;
plot(t, y1, 'y');
plot(t, y2, 'g');
plot(t, y3, 'r');
xlim([t(1), 0.3]);
xlabel('czas');
ylabel('amplituda');

% Plot pure signal input vs output
horizon = 400;
figure;
subplot(2, 1, 1);
stairs(t((end-horizon+1):end), x((end-horizon+1):end), 'b');
grid on;
xlim([t(end-horizon+1), t(end)]);
ylabel('amplituda');
title('Sygnał wejściowy');
subplot(2, 1, 2);
stairs(t((end-horizon+1):end), y3((end-horizon+1):end), 'b');
grid on;
hold on;
stairs(t((end-horizon+1):decimation:end), y3((end-horizon+1):decimation:end), 'r');
xlim([t(end-horizon+1), t(end)]);
xlabel('czas');
ylabel('amplituda');


% Calculate fft
freq_fft = 0:1:(Fs/2);
freq_fft = freq_fft(1:(end-1));

fftx = abs(fft(x((end-Fs+1):end)));
fftx = fftx(1:Fs/2);

fft1 = abs(fft(y1((end-Fs+1):end)));
fft1 = fft1(1:Fs/2);

fft2 = abs(fft(y2((end-Fs+1):end)));
fft2 = fft2(1:Fs/2);

fft3 = abs(fft(y3((end-Fs+1):end)));
fft3 = fft3(1:Fs/2);

% Plot FFT
% figure;
% semilogx(freq_fft, 20*log10(fftx), 'b');
% grid on;
% hold on;
% semilogx(freq_fft, 20*log10(fft1), 'y');
% semilogx(freq_fft, 20*log10(fft2), 'g');
% semilogx(freq_fft, 20*log10(fft3), 'r');
% xlim([freq_fft(1), freq_fft(end)]);
figure;
semilogx(freq_fft, (fftx), 'b');
grid on;
hold on;
semilogx(freq_fft, (fft1), 'y');
semilogx(freq_fft, (fft2), 'g');
semilogx(freq_fft, (fft3), 'r');
xlim([freq_fft(1), freq_fft(end)]);

% Calculate combined IIRs
sys_iir = sys1 * sys2;
B_iir = cell2mat(sys_iir.Numerator);
A_iir = cell2mat(sys_iir.Denominator);

% Generate upsampling
upsampling = 4;
y5 = zeros(length(y4) * upsampling - (upsampling - 1), 1);
y5(1:upsampling:end) = y4;
% y5(2:upsampling:end) = y4(1:end-1);
% y5(3:upsampling:end) = y4(1:end-1);
% y5(4:upsampling:end) = y4(1:end-1);
y6 = filter(B3, 1, y5) * upsampling;

horizon = 400;
figure;
stairs(t((end-horizon+1):end), y5((end-horizon+1):end), 'b');
grid on;
hold on;
stairs(t((end-horizon+1):end), y6((end-horizon+1):end), 'r');
xlim([t(end-horizon+1), t(end)]);
xlabel('czas');
ylabel('amplituda');

% Now design IIR filter for decimated sampling frequency

% Butterworth high-pass filter
Fs = 2000;

[B1, A1] = butter(2, 20/1000, 'high');
sys1 = tf(B1, A1, 1/Fs);

% Notch filter for 50 Hz
wo = 50/(Fs/2);    % this is for 50 Hz
bw = wo/5;
[B2, A2] = iirnotch(wo,bw);
sys2 = tf(B2, A2, 1/Fs);

% Calculate combined IIRs
sys_iir = sys1 * sys2;
B_iir = cell2mat(sys_iir.Numerator);
A_iir = cell2mat(sys_iir.Denominator);

[h_iir, w] = freqz(B_iir, A_iir, 4000);

% Plot filter characteristics

figure;
subplot(2, 1, 1);
semilogx(freq, 20*log10(abs(h_iir)));
grid on;
xlim([0, Fs/2]);
xlabel('Częstotliwość, Hz');
ylabel('Wzmocnienie, dB');
ylim([-150, 10]);
subplot(2, 1, 2);
semilogx(freq, angle(h_iir) * 180 / pi);
grid on;
xlim([0, Fs/2]);
xlabel('Częstotliwość, Hz');
ylabel('Przesunięcie fazowe, dB');

% Calculate IIR q15 filters for decimated frequency
k = max(abs([B1, A1]));
B_iir_hp_q15 = round(B1 / k * 2^15);
A_iir_hp_q15 = round(A1(2:end) / k * 2^15);
scale_iir_hp_q15 = round(k * 2^15);

k = max(abs([B2, A2]));
B_iir_notch_q15 = round(B2 / k * 2^15);
A_iir_notch_q15 = round(A2(2:end) / k * 2^15);
scale_iir_notch_q15 = round(k * 2^15);

% Calculate q15 filters
k = max(abs([B_iir, A_iir]));
B_iir_q15 = round(B_iir / k * 2^15);
A_iir_q15 = round(A_iir(2:end) / k * 2^15);
scale_iir_q15 = round(k * 2^15);
% Scale for FIR decimation filter with gain for normalized IIR
%k = A_iir(1) / k;
k = 1;
B_decim_q15 = round(B3 / k * 2^15);
% Scale for FIR interpolation with decimation factor
k = 1/4;
B_interp_q15 = round(B3 / k * 2^15);

save('B_iir_q15.mat', 'B_iir_q15');
save('A_iir_q15.mat', 'A_iir_q15');
save('scale_iir_q15', 'scale_iir_q15');
save('B_decim_q15.mat', 'B_decim_q15');
save('B_interp_q15.mat', 'B_interp_q15');