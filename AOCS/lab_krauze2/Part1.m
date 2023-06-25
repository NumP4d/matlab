clear;
close all;
clc;

m = 100;	% kg
k = 20000;  % N / m
C = 500;	% N * s / m

s = tf('s');

K2s = (k + C * s) / (s^2 * m + C * s + k);

Fs = 500;
tmax = 500;

t = 0:1/Fs:tmax;
t = t(1:end-1);
f = (25 - 0.5) / 500 * t + 0.5;
A = 0.05 * 2 ./ f;
intf = cumsum(f) * 1 / Fs;
y = A .* sin(2*pi*intf);
y2 = A .* chirp(t, 0.5, t(end), 25);

figure;
plot(t, y);
hold on;
grid on;
plot(t, y2, 'r--');

magic_number = 2500;

fi2 = 0.5:0.25:25.25;
f2 = [];
for i = 1:length(fi2)
	f2 = [f2, fi2(i) * ones(1, magic_number)];
end

A2 = 0.05 * 2 ./ f2;
intf2 = cumsum(f2) * 1 / Fs;
y3 = A2 .* sin(2*pi * intf2);

plot(t, y3);

% simulation

figure;
subplot(3, 1, 1);
ysim = lsim(K2s, y3, t);
plot(t, ysim);
subplot(3, 1, 2);
plot(t, y3);
ylabel('u, N');
subplot(3, 1, 3);
plot(t, f);
xlabel('time, s');

figure;
subplot(3, 1, 1);
ysim2 = lsim(K2s, y, t);
plot(t, ysim2);
subplot(3, 1, 2);
plot(t, y);
ylabel('u, N');
subplot(3, 1, 3);
plot(t, f2);
xlabel('time, s');

% Identyfikacja modelu nyquista albo chociaż bodego
rmsy_in = zeros(length(fi2), 1);
rmsy_out = zeros(length(fi2), 1);
for i = 1:length(fi2)
	rmsy_in(i) = rms(y3(((i-1) * magic_number + 1 + magic_number/10):(i * magic_number)));
	rmsy_out(i) = rms(ysim(((i-1) * magic_number + 1 + magic_number/10):(i * magic_number)));
	if (isnan(rmsy_in(i)))
    	rmsy_in(i) = 1;
    	rmsy_out(i) = 0.0001;
	end
end

mag = rmsy_out./rmsy_in;

magchirp = sqrt(pwelch(ysim2, 2048) ./ pwelch(y, 2048));
f_pwelch = 0:Fs/2048:Fs/2;
f_pwelch = f_pwelch(1:end-1);
[mag_bode, ~] = bode(K2s, 2*pi*f_pwelch);
for i = 1:length(mag_bode)
	mag_bode2(i) = mag_bode(1, 1, i);
end
figure;
scatter(fi2, mag', 'b.');
hold on;
grid on;
plot(f_pwelch(1:end/2), magchirp(1:end/2), 'r');
plot(f_pwelch, mag_bode2, 'g');
xlim([0, 25]);
legend('rms','pwelch','ideal from bode')
