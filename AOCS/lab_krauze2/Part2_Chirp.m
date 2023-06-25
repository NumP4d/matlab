% CHIRP KOD %
clear;
close all;
clc;

filePath = 'simData/passive_chirp/passive_full_prm_000_frontChirpExc_0_05';
readSimData;

t1 = tVec;
u1 = X1;
y1 = Y2;

filePath = 'simData/shp_chirp/shp_full_prm_2500_frontChirpExc_0_05';
readSimData;

t2 = tVec;
u2 = X1;
y2 = Y2;

Fs = sampleFreq;

figure;
subplot(2, 1, 1);
plot(t1, y1);
grid on;
xlim([t1(5), t1(end)]);
ylabel('y');
subplot(2, 1, 2);
plot(t1, u1);
grid on;
xlim([t1(5), t1(end)]);
ylabel('u');
xlabel('time');

figure;
subplot(2, 1, 1);
plot(t2, y2);
grid on;
xlim([t2(5), t2(end)]);
ylabel('y');
subplot(2, 1, 2);
plot(t2, u2);
grid on;
xlim([t2(5), t2(end)]);
ylabel('u');
xlabel('time');

mag1 = sqrt(pwelch(y1, 2048) ./ pwelch(u1, 2048));
mag2 = sqrt(pwelch(y2, 2048) ./ pwelch(u2, 2048));
f_pwelch = 0:Fs/2048:Fs/2;

figure;
hold on;
grid on;
plot(f_pwelch, mag1, 'b');
xlim([0, 30]);
hold on;
grid on;
plot(f_pwelch, mag2, 'r');
legend('passive', 'skyhook');