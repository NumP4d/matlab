close all;
clear all;
clc;

read_ip_data;

% Read IP data for n measurements
%filename = 'process_identification_new.dat';
%filename = '_process_identification.dat';
filename = 'process_identification_15_43_15_01.dat';
filename_silence = 'process_identification_new_silence.dat';

N = 100;    % n data packets
n = 16000;  % n samples in one data
Fs = 16000;

fid = fopen(filename, 'r');
fgets(fid);      % skip one line
output = fscanf(fid, '%d');
output = output / N;    % calculate mean from samples
fid = fopen(filename_silence, 'r');
line = fgets(fid);      % skip one line
output_silence = fscanf(fid, '%d');
output_silence = output_silence / N;    % calculate mean from samples
%gain = 10000 / 5100;
%gain = (10000 / 5100);
%gain = 5100 / 1000;
gain = 10;
%gain   = (10000 / 5100) * (10000 / 5100);
%gain = 5100 / 10000;
%output = (output - output_silence) * gain + 2048;
output = (output - mean(output)) * gain;  % make same offsets on DAC and ADC data
fclose(fid);

f = zeros(16000, 1);
f(1) = 0;

for i = 2:n
    f(i) = i * Fs / n;
end

figure;
fft_in = fft((input-2048) / 4095 * 3.3);
semilogx(f(1:(n/2)), 20*log10(abs(fft_in(1:(n/2))).^2));
xlim([f(1), f(n/2)]);
ylim([89, 90]);
grid on;
xlabel('Cz�stotliwo��, Hz');
ylabel('Widmo sygna�u, dBV');

figure;
subplot(2, 1, 1);
plot(output_silence);
grid on;
subplot(2, 1, 2);
sil_fft = fft(output_silence);
semilogx(f(1:(n/2)), 20*log10(abs(sil_fft(1:n/2)).^2));
grid on;

% output is mean from all measurements
H_w = fft(output) ./ fft(input-2048);

figure;
hold on;
grid on;

scatter(real(H_w(1:(n/2))), imag(H_w(1:(n/2))), 'b.');
% plot circle r = 1
th = 0:0.01:2*pi;
x = cos(th);
y = sin(th);
%plot(x, y, 'k--');
xlabel('$Re(Ho(e^{j\omega}))$', 'Interpreter', 'latex');
ylabel('$Im(Ho(e^{j\omega}))$', 'Interpreter', 'latex');

figure;
hold on;
grid on;
plot(real(H_w(1:(n/2))), imag(H_w(1:(n/2))), 'b');
scatter(real(H_w(1:(n/2))), imag(H_w(1:(n/2))), 'b.');
xlabel('Re(H(jw))');
ylabel('Im(H(jw))');

figure;
subplot(2, 1, 1);
%hold on;
%grid on;
semilogx(f(1:(n/2)), 20*log10(abs(H_w(1:(n/2)))), 'b');
grid on;
%scatter(real(H_w(1:(n/2))), 20*log10(abs(H_w(1:(n/2))).^2), 'b.');
xlabel('Cz�stotliwo��, Hz');
ylabel('Wzmocnienie, dB');
xlim([f(1), f(n/2)]);

subplot(2, 1, 2);
%hold on;
%grid on;
semilogx(f(1:(n/2)), (angle(H_w(1:(n/2))) * 180 / pi), 'b');
grid on;
%scatter(real(H_w(1:(n/2))), (imag(H_w(1:(n/2))) * 180 / pi), 'b.');
xlabel('Cz�stotliwo��, Hz');
ylabel('Przesuni�cie fazowe, deg');
xlim([f(1), f(n/2)]);


warunek = (f <= 3000) & (f >= 50);
xlimit = [50, 3000];

figure;
%hold on;
%grid on;
scatter(real(H_w(warunek)), imag(H_w(warunek)), 'b.');
grid on;
%polarscatter(imag(H_w(warunek)), abs(H_w(warunek)));
xlabel('Re(H(jw))');
ylabel('Im(H(jw))');

figure;
subplot(2, 1, 1);
%hold on;
%grid on;
semilogx(f(warunek), 20*log10(abs(H_w(warunek)).^2), 'b');
grid on;
%scatter(real(H_w(f <= 3000)), 20*log10(abs(H_w(f <= 3000)).^2), 'b.');
xlabel('frequency, Hz');
ylabel('magnitude, dB');
xlim(xlimit);

subplot(2, 1, 2);
%hold on;
%grid on;
semilogx(f(warunek), (angle(H_w(warunek)) * 180 / pi), 'b');
grid on;
%scatter(real(H_w(f <= 3000)), (imag(H_w(f <= 3000)) * 180 / pi), 'b.');
xlabel('frequency, Hz');
ylabel('phase, deg');
xlim(xlimit);

NB = 400;
NA = 0;
%NA = NB + 1;

w = 0:pi/(n):pi;
w = w(1:(end-1));


[B, A] = invfreqz(H_w, w, NB, NA);
% [z,p,k] = tf2zp(B, A);     % Get Zero-Pole form
% 
% figure;
% scatter(real(z), imag(z), 'bo');
% hold on;
% grid on;
% scatter(real(p), imag(p), 'rx');
% th = 0:0.01:2*pi;
% x = cos(th);
% y = sin(th);
% plot(x, y, ':', 'Color', [0.3,0.3,0.3]);

[h_n, w_n] = freqz(B, A, 16000);

sys = tf(B, A, 1/Fs);

%[Y, T] = impulse(sys, NB+10, Fs);

figure;
t = 0:1/Fs:NB/Fs;
%t = t(1:end-1);
stem(t, B);


figure;
plot(real(h_n(1:(n/2))), imag(h_n(1:(n/2))), 'r');
hold on;
grid on;
scatter(real(H_w(warunek)), imag(H_w(warunek)), 'b.');
xlabel('Re(H(jw))');
ylabel('Im(H(jw))');

% Save data
H_w = H_w(1:(n/2));
save('H_w.mat', 'H_w');
