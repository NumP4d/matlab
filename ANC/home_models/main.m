close all;
clear;
clc;

%% Parameters for measurement data
N  = 2048;
Fs = 8000;
Ts = 1/Fs;
time = 0:Ts:(Fs-1)*Ts;
noise_ref_gain  = 2 / 2;
%noise_err_gain  = 20 / 2;
noise_err_gain  = 2 / 2;
cancel_ref_gain = 2 / 2;
cancel_err_gain = 2 / 2;
excitation_gain = 2 / 2;
resolution      = 2048;

%% Read data file contents
% excitationSignal = read_data('excitationSignal.dat');
% noise_ref_sum    = read_data('noise_ref_gain2.dat');
% noise_err_sum    = read_data('noise_err_gain20.dat');
% cancel_ref_sum   = read_data('cancel_ref_gain10.dat');
% cancel_err_sum   = read_data('cancel_err_gain10.dat');

excitationSignal = read_data('excitationSignal.dat');
noise_ref_sum    = read_data('lab_identification/proper_noise_ref_gain2.dat');
noise_err_sum    = read_data('lab_identification/proper_noise_err_gain10.dat');
cancel_ref_sum   = read_data('lab_identification/proper_cancel_ref_gain20.dat');
cancel_err_sum   = read_data('lab_identification/proper_cancel_err_gain20.dat');


%% Normalize data with proper gain factors
excitationSignal = excitationSignal * excitation_gain / resolution;
noise_ref_sum    = noise_ref_sum    * noise_ref_gain  / resolution;
noise_err_sum    = noise_err_sum    * noise_err_gain  / resolution;
cancel_ref_sum   = cancel_ref_sum   * cancel_ref_gain / resolution;
cancel_err_sum   = cancel_err_sum   * cancel_err_gain / resolution;

%% Remove data offset
excitationSignal = excitationSignal - mean(excitationSignal);
noise_ref_sum    = noise_ref_sum    - mean(noise_ref_sum);
noise_err_sum    = noise_err_sum    - mean(noise_err_sum);
cancel_ref_sum   = cancel_ref_sum   - mean(cancel_ref_sum);
cancel_err_sum   = cancel_err_sum   - mean(cancel_err_sum);

%% Calculate average data
noise_ref  = noise_ref_sum  / N;
noise_err  = noise_err_sum  / N;
cancel_ref = cancel_ref_sum / N;
cancel_err = cancel_err_sum / N;

%% Plot result data
% Noise speaker dynamic paths
figure;
subplot(3, 1, 1);
plot(time, noise_ref, 'b');
grid on;
ylabel('Mikrofon referencyjny');
subplot(3, 1, 2);
plot(time, noise_err, 'b');
grid on;
ylabel('Mikrofon błedu');
subplot(3, 1, 3);
plot(time, excitationSignal, 'b');
grid on;
xlabel('czas');

% Cancelling speaker dynamic paths
figure;
subplot(3, 1, 1);
plot(time, cancel_ref, 'b');
grid on;
ylabel('Mikrofon referencyjny');
subplot(3, 1, 2);
plot(time, cancel_err, 'b');
grid on;
ylabel('Mikrofon błędu');
subplot(3, 1, 3);
plot(time, excitationSignal, 'b');
grid on;
xlabel('czas');

%% Dynamic paths identification
% Dynamic filters length
nB = 2047;
nA = 0;     % Only FIR model

% Frequency vector
f = 0:1:Fs/2;
f = f(1:end-1);

[noise_ref_B, noise_ref_A, noise_ref_H_w,  ...
 noise_ref_mag, noise_ref_phase_shift]     ...
    = model_identification(noise_ref, excitationSignal, nB, nA);
[noise_err_B, noise_err_A, noise_err_H_w,  ...
 noise_err_mag, noise_err_phase_shift]     ...
    = model_identification(noise_err, excitationSignal, nB, nA);
[cancel_ref_B, cancel_ref_A, cancel_ref_H_w,  ...
 cancel_ref_mag, cancel_ref_phase_shift]     ...
    = model_identification(cancel_ref, excitationSignal, nB, nA);
[cancel_err_B, cancel_err_A, cancel_err_H_w,  ...
 cancel_err_mag, cancel_err_phase_shift]     ...
    = model_identification(cancel_err, excitationSignal, nB, nA);

%% Plot identified models

figure;
%subplot(2, 2, 1);
scatter(real(noise_ref_H_w), imag(noise_ref_H_w), 'b.');
grid on;
hold on;
[h_n, ~] = freqz(noise_ref_B, noise_ref_A, Fs);
plot(real(h_n(1:(end/2))), imag(h_n(1:(end/2))), 'r');
xlabel('$Re(H_{nr}(e^{j\omega}))$', 'Interpreter', 'latex');
ylabel('$Im(H_{nr}(e^{j\omega}))$', 'Interpreter', 'latex');
figure;
%subplot(2, 2, 2);
scatter(real(noise_err_H_w), imag(noise_err_H_w), 'b.');
grid on;
hold on;
[h_n, ~] = freqz(noise_err_B, noise_err_A, Fs);
plot(real(h_n(1:(end/2))), imag(h_n(1:(end/2))), 'r');
xlabel('$Re(H_{ne}(e^{j\omega}))$', 'Interpreter', 'latex');
ylabel('$Im(H_{ne}(e^{j\omega}))$', 'Interpreter', 'latex');
figure;
%subplot(2, 2, 3);
scatter(real(cancel_ref_H_w), imag(cancel_ref_H_w), 'b.');
grid on;
hold on;
[h_n, ~] = freqz(cancel_ref_B, cancel_ref_A, Fs);
plot(real(h_n(1:(end/2))), imag(h_n(1:(end/2))), 'r');
xlabel('$Re(H_{cr}(e^{j\omega}))$', 'Interpreter', 'latex');
ylabel('$Im(Ho(e^{j\omega}))$', 'Interpreter', 'latex');
figure;
%subplot(2, 2, 4);
scatter(real(cancel_err_H_w), imag(cancel_err_H_w), 'b.');
grid on;
hold on;
[h_n, ~] = freqz(cancel_err_B, cancel_err_A, Fs);
plot(real(h_n(1:(end/2))), imag(h_n(1:(end/2))), 'r');
xlabel('$Re(H_{ce}(e^{j\omega}))$', 'Interpreter', 'latex');
ylabel('$Im(H_{ce}(e^{j\omega}))$', 'Interpreter', 'latex');

f = 1:Fs/2;
figure;
subplot(2, 1, 1);
plot(f, 20*log10(abs(cancel_ref_H_w)), 'b.');
[h_n, ~] = freqz(cancel_ref_B, cancel_ref_A, Fs);
hold on;
grid on;
plot(f, 20*log10(abs(h_n(1:(end/2)))), 'r');
ylabel('Wzmocnienie ref, dB');
subplot(2, 1, 2);
plot(f, 20*log10(abs(cancel_err_H_w)), 'b.');
[h_n, ~] = freqz(cancel_err_B, cancel_err_A, Fs);
hold on;
grid on;
plot(f, 20*log10(abs(h_n(1:(end/2)))), 'r');
xlabel('Częstotliwość, Hz');
ylabel('Wzmocnienie err, dB');

f = 1:Fs/2;
figure;
subplot(2, 1, 1);
plot(f, 20*log10(abs(noise_ref_H_w)), 'b.');
[h_n, ~] = freqz(noise_ref_B, noise_ref_A, Fs);
hold on;
grid on;
plot(f, 20*log10(abs(h_n(1:(end/2)))), 'r');
ylabel('Wzmocnienie ref, dB');
subplot(2, 1, 2);
plot(f, 20*log10(abs(noise_err_H_w)), 'b.');
[h_n, ~] = freqz(noise_err_B, noise_err_A, Fs);
hold on;
grid on;
plot(f, 20*log10(abs(h_n(1:(end/2)))), 'r');
xlabel('Częstotliwość, Hz');
ylabel('Wzmocnienie err, dB');

figure;

%% Plot impulse response of models
t = 0:1/Fs:1/Fs*nB;

plot(f, 20*log10(abs(cancel_err_H_w)), 'b.');

%% Plot impulse response of models
t = 0:1/Fs:1/Fs*nB;

figure;
subplot(2, 2, 1);
stem(t, noise_ref_B, 'b');
grid on;
subplot(2, 2, 2);
stem(t, noise_err_B, 'b');
grid on;
subplot(2, 2, 3);
stem(t, cancel_ref_B, 'b');
grid on;
subplot(2, 2, 4);
stem(t, cancel_err_B, 'b');
grid on;

%% Save model parameters
save('noise_ref_B.mat', 'noise_ref_B');
save('noise_err_B.mat', 'noise_err_B');
save('cancel_ref_B.mat', 'cancel_ref_B');
save('cancel_err_B.mat', 'cancel_err_B');