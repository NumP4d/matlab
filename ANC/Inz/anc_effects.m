close all;
%clear all;
clc;


% teoretyczne wartoœci
c = [0.9681   -1.6481    0.8425    2.1800    0.3146   -0.2502];
Ho_w = ANC_Ho_w(c);
J_w = 10 * log10(abs(1 + Ho_w).^2);

% Read IP data for n measurements
%filename = 'process_identification_new.dat';
%filename = '_process_identification.dat';
%filename_on  = 'anc_411Hz_new';
%filename_off = 'no_anc_411Hz_new';
%filename_on = "anc_noise.dat";
%filename_off = "no_anc_noise.dat";
%filename_on = "anc_test_signal.dat";
%filename_off = "no_anc_test_signal.dat";
%filename_on = "anc_test_signal_mean.dat";
%filename_off = "no_anc_test_signal_mean.dat";
%filename_on  = 'anc_442Hz.dat';
%filename_off = 'no_anc_442Hz.dat';
filename_on = 'anc_test_signal.dat';
filename_off = 'no_anc_test_signal.dat';
%filename_on = 'anc_440Hz.dat';
%filename_off = 'no_anc_440Hz.dat';

n = 16000;  % n samples in one data
Fs = 16000;
%mean_div = 1;
mean_div = 20;

p0 = 2 * 10^(-5); % Pa
k = 2.8680;

fid = fopen(filename_on, 'r');
fgets(fid);      % skip one line
fgets(fid);      % skip second line
output = fscanf(fid, '%d,%d');
%adc_on = output(:, 1);
%dac_on = output(:, 1);
adc_on = output(1:2:end);
dac_on = output(2:2:end);
p_on = (adc_on / 4095 * 3.3) / k;
spl_on = 10 * log10(abs(fft(p_on).^2) / (p0.^2));
fclose(fid);
fid = fopen(filename_off, 'r');
fgets(fid);      % skip one line
fgets(fid);      % skip second line
output = fscanf(fid, '%d,%d');
adc_off = output(1:2:end);
p_off = (adc_on / 4095 * 3.3) / k;
spl_off = 10 * log10(abs(fft(p_off).^2) / (p0.^2));
dac_off = output(2:2:end);
fclose(fid);

adc_on = adc_on / mean_div;
adc_off = adc_off / mean_div;

f = zeros(16000, 1);
f(1) = 0;

for i = 2:n
    f(i) = i * Fs / n;
end

% figure;
% scatter(real(H_w), imag(H_w));

% figure;
% hold on;
% semilogx(f(1:(n/2)), 20*log10(abs(fft_off(1:n/2)).^2), 'r');
% semilogx(f(1:(n/2)), 20*log10(abs(fft_on(1:n/2)).^2), 'b');
% %semilogx(f(2:(n/2)), spl_off(2:n/2), 'r');
% %semilogx(f(2:(n/2)), spl_on(2:n/2), 'b');
% xlim([f(2), f(n/2)]);
% grid on;
% xlim([160, 680]);

fft_on = fft(adc_on);
fft_off = fft(adc_off);

figure;
semilogx(f(101:1001)-1, 20*log10(abs(fft_off(101:1001)).^2), 'r');
hold on;
grid on;
semilogx(f(101:1001)-1, 20*log10(abs(fft_on(101:1001)).^2), 'b');
xlim([100, 1000]);
New_XTickLabel = get(gca,'xtick');
set(gca,'XTickLabel',New_XTickLabel);
xlabel('Czêstotliwoœæ, Hz');
ylabel('Widmo mocy ADC, dB');
legend('ANC off', 'ANC on');

figure;
semilogx(f(200:(n/2)), 20*log10(abs(fft_off(200:n/2))) - 20*log10(abs(fft_on(200:n/2))), 'b');
grid on;
hold on;
semilogx(f(200:n/2), J_w(200:end), 'r');
xlim([f(1), f(n/2)]);
legend('zmierzone', 'teoretyczne');
xlabel('Czêstotliwoœæ, Hz');
ylabel('T³umienie zak³óceñ, dB');
%xlim([160, 680]);
%xlim([f(2), f(n/2)]);
xlim([200, 4000]);

figure;
subplot(2, 1, 1);
plot(adc_off, 'r');
hold on;
ylabel('Wartoœæ na ADC');
xlabel('nr probki');
plot(adc_on, 'b');
xlim([1, 500]);
legend('ANC off', 'ANC on');
%plot(adc_off, 'r.');
%plot(adc_on, 'b.');
grid on;
subplot(2, 1, 2);
plot(dac_off, 'r');
hold on;
ylabel('Wartoœæ na DAC');
plot(dac_on, 'b');
legend('ANC off', 'ANC on');
xlim([1, 500]);
%plot(dac_on, 'b.');
%plot(dac_off, 'r.');
xlabel('nr probki');
grid on;

% figure;
% adc_offset = mean(adc_on);
% dac_offset = 2048;
% fdac = fft(dac_on - dac_offset);
% fdac = fdac .* H_w;
% dac_sig = real(ifft(fdac));
% plot((adc_on - adc_offset) - dac_sig, 'r');
% hold on;
% grid on;
% xlim([1, 1000]);
% plot(dac_sig, 'b');
% plot(dac_on - dac_off, 'k');
% plot(adc_on - adc_offset, 'g');
% 
% figure;
% adc_offset = mean(adc_on);
% dac_offset = 2048;
% fadc_on = 20*log10(abs(fft(adc_on - adc_offset)).^2);
% fadc_off = 20*log10(abs(fft(adc_off - mean(adc_off))).^2);
% reduction = fadc_off - fadc_on;
% semilogx(f(1:n/2), reduction(1:n/2), 'b');
% grid on;
% hold on;
% %xlim([1, n/2]);
% xlim([160, 650]);
% ylim([-10, 12]);
% [maxred, imax] = max(reduction(160:650));
% scatter(160+imax-1, maxred, 'r');