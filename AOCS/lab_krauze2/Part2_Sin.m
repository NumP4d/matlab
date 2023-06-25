% SINUS ZWYKLY KOD %
clear;
close all;
clc;

filePath = 'simData/passive_sin/passive_full_prm_000_frontSinExc_0_05';
readSimData;

t1 = tVec;
u1 = X1;
y1 = Y2;

filePath = 'simData/shp_sin/shp_full_prm_1500_frontSinExc_0_05';
readSimData;

t2 = tVec;
u2 = X1;
y2 = Y2;

figure;
subplot(2, 1, 1);
plot(t1, y1);
grid on;
xlim([t1(1), t1(end)]);
ylabel('y');
subplot(2, 1, 2);
plot(t1, u1);
grid on;
xlim([t1(1), t1(end)]);

figure;
subplot(2, 1, 1);
plot(t2, y2);
grid on;
xlim([t2(1), t2(end)]);
ylabel('y');
subplot(2, 1, 2);
plot(t2, u2);
grid on;
xlim([t2(1), t2(end)]);
ylabel('u');
xlabel('time');

offset = 0;
for freqPtr =  1: length(fRange)             	 
  startPtr = addStartSampleVec(freqPtr);
  endPtr = endSampleVec(freqPtr);
  rms_y(freqPtr) = rms(y1((startPtr + offset):endPtr));
  rms_u(freqPtr) = rms(u1((startPtr + offset):endPtr));
end

mag1 = rms_y ./ rms_u;

offset = 0;
rms_y = 0;
rms_u = 0;
for freqPtr =  1: length(fRange)             	 
  startPtr = addStartSampleVec(freqPtr);
  endPtr = endSampleVec(freqPtr);
  rms_y(freqPtr) = rms(y2((startPtr + offset):endPtr));
  rms_u(freqPtr) = rms(u2((startPtr + offset):endPtr));
end

mag2 = rms_y ./ rms_u;

figure;
plot(fRange, mag1, 'b');
hold on;
grid on;
plot(fRange, mag2, 'r');
plot(fRange, mag1, 'b.');
plot(fRange, mag2, 'r.');
legend('passive', 'skyhook');
