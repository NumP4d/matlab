clear;
close all;
clc;

filename = 'speed11.CSV';

% Read proper headers
r = 8;
c = 1;

A = csvread(filename, r, c);

time        = A(:, 1);
rpm         = A(:, 2);
load        = A(:, 3);
speed       = A(:, 4);
consumption = A(:, 5);

start_time  = 4.64;
tim_idx = time >= start_time;
time = time(tim_idx) - start_time;
rpm = rpm(tim_idx);
load = load(tim_idx);
speed = speed(tim_idx);
consumption = consumption(tim_idx);

figure;
subplot(2, 2, 1);
plot(time, rpm);
xlim([time(1), time(end)]);
grid on;
ylabel('engine speed, rpm');

subplot(2, 2, 2);
plot(time, load);
xlim([time(1), time(end)]);
grid on;
ylabel('engine load, m/s');

subplot(2, 2, 3);
plot(time, speed);
xlim([time(1), time(end)]);
grid on;
ylabel('road speed, km/h');

subplot(2, 2, 4);
plot(time, consumption);
xlim([time(1), time(end)]);
grid on;
ylabel('consumption, l/h');

xlabel('time, s');

% Total comsumption calculation
total_consumption = zeros(size(time));

for i = 2:length(time)
    h = (time(i) - time(i - 1)) / 3600; % time to hour
    total_consumption(i) = total_consumption(i - 1) + (consumption(i) + consumption(i - 1)) * h / 2;
end

total_road = zeros(size(time));

for i = 2:length(time)
    h = (time(i) - time(i - 1)) / 3600; % time to hour
    total_road(i) = total_road(i - 1) + (speed(i) + speed(i - 1)) * h / 2;
end

mean_consumption = 100 * total_consumption ./ total_road;

figure;
subplot(3, 1, 1);
plot(time, total_consumption);
subplot(3, 1, 2);
plot(time, total_road);
subplot(3, 1, 3);
plot(time, mean_consumption);

disp(['Total consumption during measurement: ', num2str(total_consumption(end)), ' L']);
disp(['Total road trip during measurement: ', num2str(total_road(end)), ' km']);
disp(['Mean consumption: ', num2str(mean_consumption(end)), ' L/100km']);

tmp_time_zero = time(speed <= 0);
tmp_time_hundread = time(speed >= 100);
zero_to_hundread = tmp_time_hundread(1) - tmp_time_zero(end);

disp(['Zero to 100 km/h time: ', num2str(zero_to_hundread), ' s']);