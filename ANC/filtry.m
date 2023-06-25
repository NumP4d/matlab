clear;
close all;
clc;

freq = 200;

offset = 200;

Fs = 8000;

f = [0, 500, 500, 4000] / 4000;
m = [1, 1, 0, 0];
N = 31;

B = fir2(N, f, m);
[h, w] = freqz(B, 1, 2048);
w = w / pi * 4000;

t = 0:1/8000:1;
x = 10 * sin(2*pi*freq*t) + offset + 50 * sin(2*pi*50*t);

[B2, A2] = butter(1, 20/4000, 'high');

sys1 = tf(B2, A2, 1/Fs);
sys2 = tf(B, 1, 1/Fs);
z = tf('z', 1/Fs);
sys3 = 2000*(1 - 2*cos(2*pi*50*1/Fs) * z^(-1) + z^(-2));
Bz = 2000 * [1, -2 * cos(2*pi*50*1/Fs), 1];
[h, w] = freqz(Bz, 1, 4000);
freq = w / pi * 4000;
figure;
subplot(3, 1, 1);
semilogx(freq, 20*log10(abs(h)));
grid on;
xlim([0, 4000]);
xlabel('Frequency, Hz');
ylabel('Magnitude, dB');
m = zeros(500, 1);
[~, zeroing_freq] = min(abs(h));
for i = 1:500
    if (i ~= zeroing_freq)
        m(i) = 1 / abs(h(i));
    else
        m(i) = 1;
    end
end
abs(h)
f = [w(1:500)'/pi, 500/4000, 1];
m = [m', 0, 0];

B2 = fir2(31, f, m);
[h, ~] = freqz(B2, 1, 4000);

wo = 50/(Fs/2);
bw = wo/10;
[b,a] = iirnotch(wo,bw);
sys_n = tf(b, a, 1/Fs);

sys_B2 = tf(B2, 1, 1/Fs);
%sys_k = sys1 * sys3 * sys_B2;
sys_k = sys1 * sys_n * sys2;

B_k = cell2mat(sys_k.Numerator);
A_k = cell2mat(sys_k.Denominator);
A_k = A_k(A_k ~= 0);
[h_k, ~] = freqz(B_k, A_k, 4000);

subplot(3, 1, 2);
semilogx(freq, 20*log10(abs(h)));
grid on;
xlim([0, 4000]);
xlabel('Frequency, Hz');
ylabel('Magnitude, dB');

subplot(3, 1, 3);
semilogx(freq, 20*log10(abs(h_k)));
grid on;
xlim([0, 4000]);
xlabel('Frequency, Hz');
ylabel('Magnitude, dB');
title('output filter combined');

%Bz = cell2mat(sys3.Numerator);
%Az = cell2mat(sys3.Denominator);
%sys = sys1 * sys3 * sys2;
%sys = sys1 * sys2;
sys = sys3;

Bn = cell2mat(sys.Numerator);
An = cell2mat(sys.Denominator);
%An = An((end-1):end);
An = An(An ~= 0);

[h, w] = freqz(Bn, An, 2048);
w = w / pi * 4000;

%f = 1 / 4000 * [0, 20, 20, 48, 48, 52, 52, 500, 500, 4000];
%m = [0, 0, 1, 1, 0, 0, 1, 1, 0, 0];
f = 1 / 4000 * [0, 48, 48, 52, 52, 4000];
m = [1, 1, 0, 0, 1, 1];
B3 = firls(1024, f, m);

[h, w] = freqz(B3, 1, 4000);
w = w / pi * 4000;

figure;
m(m == 0) = -60;
m(m == 1) = 0;
semilogx(f*4000, m, 'r');
hold on;
semilogx(freq, 20*log10(abs(h)), 'b');
grid on;
xlim([0, 4000]);
xlabel('Frequency, Hz');
ylabel('Magnitude, dB');
legend('ideal', 'fir');

y = filter(B, 1, x);
y2 = filter(B2, A2, x);
y3 = filter(B_k, 1, y2);
y4 = filter(Bn, An, x);

figure;
semilogx(w, 20*log10(abs(h)));
grid on;
xlim([0, 4000]);
xlabel('Frequency, Hz');
ylabel('Magnitude, dB');

figure;
plot(t, x, 'b');
grid on;
hold on;
plot(t, y, 'r');
plot(t, y3, 'g');
%plot(t, y4, 'k--');
xlim([t(1), t(end)]);
ylim([-200, 250]);