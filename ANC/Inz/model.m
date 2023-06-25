close all;
clear all;
clc;

read_ip_data;

% Read IP data for n measurements

n = 10;
N = 16000;
Fs = 16000;

output = zeros(n, N);

for i = 1:n
    fid = fopen(['process_identification', num2str(i)], 'r');
    line = fgets(fid); % skip one line
    output(i, :) = fscanf(fid, '%d')';
    fclose(fid);
end
% output is mean from all measurements
H_w = fft(mean(output)) ./ fft(input');

N = 16000;

w = zeros(16000, 1);
w(1) = 0;

for i = 2:N
    w(i) = 2 * pi * i * Fs / N;
end



figure;
hold on;
grid on;

scatter(real(H_w(1:(N/2))), imag(H_w(1:(N/2))), 'b.');
xlabel('Re(H(jw))');
ylabel('Im(H(jw))');

figure;
hold on;
grid on;
plot(real(H_w), imag(H_w), 'b');
scatter(real(H_w(1:(N/2))), imag(H_w(1:(N/2))), 'b.');
xlabel('Re(H(jw))');
ylabel('Im(H(jw))');

figure;
subplot(2, 1, 1);
hold on;
grid on;
plot(w(1:(N/2)), 20*log10(abs(H_w(1:(N/2))).^2), 'b');
scatter(real(H_w(1:(N/2))), 20*log10(abs(H_w(1:(N/2))).^2), 'b.');
xlabel('frequency, Hz');
ylabel('magnitude, dB');
xlim([w(1), w(N/2)]);

subplot(2, 1, 2);
hold on;
grid on;
plot(w(1:(N/2)), (imag(H_w(1:(N/2))) * 180 / pi), 'b');
scatter(real(H_w(1:(N/2))), (imag(H_w(1:(N/2))) * 180 / pi), 'b.');
xlabel('frequency, Hz');
ylabel('phase, deg');
xlim([w(1), w(N/2)]);

% Save data
H_w = H_w(1:(N/2));
save('H_w.mat', 'H_w');