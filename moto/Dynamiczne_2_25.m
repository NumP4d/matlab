clear;
close all;
clc;

filename = 'logi-dynamiczne-2-25.CSV';
%filename = 'LOG-01-013-025-xxx.CSV';
%filename = '1.8T AEB dynamiczne 003+025.CSV';
%filename = 'LOG-01-002-025-xxx.csv';
%filename = 'LOG-01-003-025-xxx.csv';
%filename = 'LOG-01-002-025-xxx.CSV';
%filename = 'LOG-01-xxx-002-025.csv';

% Read proper headers
r = 8;
c = 1;
%c = 6;

A = csvread(filename, r, c);

time1       = A(:, 1);
rpm         = A(:, 2);
load        = A(:, 3);
inj_period  = A(:, 4);
air_mass_in = A(:, 5);

time2       = A(:, 6);
spec_load   = A(:, 7);
load_corr   = A(:, 8);
act_load    = A(:, 9);
valve_cycle = A(:, 10);

start_time  = 0;
%end_time    = 25.4;
end_time = max([time1(end), time2(end)]);
tim1_idx = (time1 >= start_time) & (time1 <= end_time);
tim2_idx = (time2 >= start_time) & (time2 <= end_time);

time1 = time1(tim1_idx) - start_time;
rpm = rpm(tim1_idx);
load = load(tim1_idx);
inj_period = inj_period(tim1_idx);
air_mass_in = air_mass_in(tim1_idx);

time2 = time2(tim2_idx) - start_time;
spec_load = spec_load(tim2_idx);
load_corr = load_corr(tim2_idx);
act_load = act_load(tim2_idx);
valve_cycle = valve_cycle(tim2_idx);

figure;
subplot(2, 2, 1);
plot(time1, rpm);
xlim([time1(1), time1(end)]);
grid on;
ylabel('engine speed, rpm');

subplot(2, 2, 2);
plot(time1, load);
xlim([time1(1), time1(end)]);
grid on;
ylabel('engine load, m/s');

subplot(2, 2, 3);
plot(time1, inj_period);
xlim([time1(1), time1(end)]);
grid on;
ylabel('injection period, m/s');

subplot(2, 2, 4);
plot(time1, air_mass_in);
xlim([time1(1), time1(end)]);
grid on;
ylabel('air mass in, g/s');

figure;
subplot(3, 1, 1);
plot(time1, rpm);
xlim([time1(1), time1(end)]);
grid on;
ylabel('engine speed, rpm');

subplot(3, 1, 2);
plot(time2, spec_load, 'r');
hold on;
plot(time2, act_load, 'b');
plot(time2, load_corr, 'g');
xlim([time2(1), time2(end)]);
grid on;
legend('specified', 'actual', 'correction');
ylabel('load, m/s');

subplot(3, 1, 3);
plot(time2, valve_cycle);
xlim([time2(1), time2(end)]);
grid on;
ylabel('valve cycle, %');

xlabel('time, s');