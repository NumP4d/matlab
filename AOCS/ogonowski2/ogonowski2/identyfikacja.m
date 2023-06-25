clear;
close all;
clc;

x = load('AoCS_EMM.mat');

Ts = 0.2;

t = 0:Ts:(Ts*length(x.x_main_SP) - Ts)';

u_main = x.x_main_SP;
u_rec = x.x_rec_SP;
u_add = x.x_add1_SP;

y_main = x.v_main;
y_rec = x.v_rec;
y_add = x.v_add1;

figure;
subplot(2, 1, 1);
plot(t, y_main);
subplot(2, 1, 2);
plot(t, u_main);
figure;
subplot(2, 1, 1);
plot(t, y_add);
subplot(2, 1, 2);
plot(t, u_add);
figure;
subplot(2, 1, 1);
plot(t, y_rec);
subplot(2, 1, 2);
plot(t, u_rec);

new_u_main = {};
new_u_rec = {};
new_u_add = {};
new_y_main = {};
new_y_rec = {};
new_y_add = {};
new_t_main = {};
new_t_rec = {};
new_t_add = {};

new_u_main{1} = u_main(1);
new_u_rec{1} = u_rec(1);
new_u_add{1} = u_add(1);
new_y_main{1} = y_main(1);
new_y_rec{1} = y_rec(1);
new_y_add{1} = y_add(1);
new_t_main{1} = t(1);
new_t_rec{1} = t(1);
new_t_add{1} = t(1);

k_main = 1;
k_rec = 1;
k_add = 1;

removed_main = 0;

min_length = 30;

offset_y_main = mean(y_main(u_main == 0));
offset_y_add = mean(y_add(u_add == 0));
offset_y_rec = mean(y_rec(u_rec == 0));

y_main = y_main - offset_y_main;
y_add = y_add - offset_y_add;
y_rec = y_rec - offset_y_rec;

for i = 2:length(t)
    if (u_main(i) ~= u_main(i-1))
        % Remove if there is not enough length for this SP
        if (length(new_u_main{k_main}) > min_length)
            k_main = k_main + 1;
        else
            removed_main = removed_main + 1;
        end
        new_u_main{k_main} = [];
        new_y_main{k_main} = [];
        new_t_main{k_main} = [];
    end
    new_u_main{k_main} = [new_u_main{k_main}, u_main(i)];
    new_y_main{k_main} = [new_y_main{k_main}, y_main(i)];
    new_t_main{k_main} = [new_t_main{k_main}, t(i)];
    if (u_main(i) ~= u_main(i-1))
        % Remove if there is not enough length for this SP
        if (length(new_u_add{k_add}) > min_length)
            k_add = k_add + 1;
        end
        new_u_add{k_add} = [];
        new_y_add{k_add} = [];
        new_t_add{k_add} = [];
    end
    new_u_add{k_add} = [new_u_add{k_add}, u_add(i)];
    new_y_add{k_add} = [new_y_add{k_add}, y_add(i)];
    new_t_add{k_add} = [new_t_add{k_add}, t(i)];
    if (u_main(i) ~= u_main(i-1))
        % Remove if there is not enough length for this SP
        if (length(new_u_rec{k_rec}) > min_length)
            k_rec = k_rec + 1;
        end
        new_u_rec{k_rec} = [];
        new_y_rec{k_rec} = [];
        new_t_rec{k_rec} = [];
    end
    new_u_rec{k_rec} = [new_u_rec{k_rec}, u_rec(i)];
    new_y_rec{k_rec} = [new_y_rec{k_rec}, y_rec(i)];
    new_t_rec{k_rec} = [new_t_rec{k_rec}, t(i)];
end

k_main = 1250;
figure;
subplot(2, 1, 1);
plot([new_t_main{k_main}, new_t_main{k_main + 1}], [new_y_main{k_main}, new_y_main{k_main + 1}]);
subplot(2, 1, 2);
plot([new_t_main{k_main}, new_t_main{k_main + 1}], [new_u_main{k_main}, new_u_main{k_main + 1}]);

k_rec = 5;
figure;
subplot(2, 1, 1);
plot([new_t_rec{k_rec}, new_t_rec{k_rec + 1}], [new_y_rec{k_rec}, new_y_rec{k_rec + 1}]);
subplot(2, 1, 2);
plot([new_t_rec{k_rec}, new_t_rec{k_rec + 1}], [new_u_rec{k_rec}, new_u_rec{k_rec + 1}]);

figure;
subplot(3, 1, 1);
plot(t, y_main, 'b');
hold on;
grid on;

b_main = [];
params_main = [];
it = 1;

% MNK for main:
for i = 1:length(new_u_main)
   if (new_u_main{i} == 0)
       continue;
   end
   y = new_y_main{i}(2:end)';
   u = [new_u_main{i}(1:end-1)', -new_y_main{i}(1:end-1)'];
   b_main(:, it) = (u'*u)^(-1) * u' * y;
   y_mod = u * b_main(:, it);
   plot(new_t_main{i}(2:end), y_mod, 'r--');
   gain = b_main(1, it) ./ (1 + b_main(2, it));
   time_constant = - Ts ./ (1 + 1 ./ b_main(2, it));
   params_main(:, it) = [gain; time_constant];
   it = it + 1;
end

subplot(3, 1, 2);
plot(t, y_add, 'b');
hold on;
grid on;

b_add = [];
params_add = [];
it = 1;

% MNK for add:
for i = 1:length(new_u_add)
   if (new_u_add{i} == 0)
       continue;
   end
   y = new_y_add{i}(2:end)';
   u = [new_u_add{i}(1:end-1)', -new_y_add{i}(1:end-1)'];
   b_add(:, it) = (u'*u)^(-1) * u' * y;
   y_mod = u * b_add(:, it);
   plot(new_t_add{i}(2:end), y_mod, 'r--');
   gain = b_add(1, it) ./ (1 + b_add(2, it));
   time_constant = - Ts ./ (1 + 1 ./ b_add(2, it));
   params_add(:, it) = [gain; time_constant];
   it = it + 1;
end

subplot(3, 1, 3);
plot(t, y_rec, 'b');
hold on;
grid on;

b_rec = [];
params_rec = [];
it = 1;

% MNK for rec:
for i = 1:length(new_u_rec)
   if (new_u_rec{i} == 0)
       continue;
   end
   y = new_y_rec{i}(2:end)';
   u = [new_u_rec{i}(1:end-1)', -new_y_rec{i}(1:end-1)'];
   b_rec(:, it) = (u'*u)^(-1) * u' * y;
   y_mod = u * b_rec(:, it);
   plot(new_t_rec{i}(2:end), y_mod, 'r--');
   gain = b_rec(1, it) ./ (1 + b_rec(2, it));
   time_constant = - Ts ./ (1 + 1 ./ b_rec(2, it));
   params_rec(:, it) = [gain; time_constant];
   it = it + 1;
end

knn_main = 8;
[idx_main, C_main] = kmeans(b_main', knn_main);
knn_add = 8;
[idx_add, C_add] = kmeans(b_add', knn_add);
knn_rec = 8;
[idx_rec, C_rec] = kmeans(b_rec', knn_rec);

figure;
subplot(3, 1, 1);
hold on;
for i = 1:knn_main
    scatter(b_main(1, idx_main == i), b_main(2, idx_main == i), '.');
end
scatter(C_main(:, 1), C_main(:, 2), 'ko', 'LineWidth',3);
xlabel('b0');
ylabel('a1');
title('MAIN');
subplot(3, 1, 2);
hold on;
for i = 1:knn_add
    scatter(b_add(1, idx_add == i), b_add(2, idx_add == i), '.');
end
scatter(C_add(:, 1), C_add(:, 2), 'ko','LineWidth',3);
xlabel('b0');
ylabel('a1');
title('ADD');
subplot(3, 1, 3);
hold on;
for i = 1:knn_rec
    scatter(b_rec(1, idx_rec == i), b_rec(2, idx_rec == i), '.');
end
scatter(C_rec(:, 1), C_rec(:, 2), 'ko','LineWidth',3);
xlabel('b0');
ylabel('a1');
title('REC');

% Translate to continous parameters
% First is gain, second is Time constant
C_main_c(:, 1) = C_main(:, 1) ./ (1 + C_main(:, 2));
C_main_c(:, 2) = - Ts ./ (1 + 1 ./ C_main(:, 2));
C_add_c(:, 1) = C_add(:, 1) ./ (1 + C_add(:, 2));
C_add_c(:, 2) = - Ts ./ (1 + 1 ./ C_add(:, 2));
C_rec_c(:, 1) = C_rec(:, 1) ./ (1 + C_rec(:, 2));
C_rec_c(:, 2) = - Ts ./ (1 + 1 ./ C_rec(:, 2));

% PI tuning parameters for lambda method:
% kr = T / (k * (lambda + Tdelay));
% Ti = T;
lambda = 0.8;
Tdelay = Ts;

PI_kp_main = C_main_c(:, 2) ./ ( C_main_c(:, 1) .* (lambda + Tdelay));
PI_Ti_main = C_main_c(:, 2);

PI_kp_add = C_add_c(:, 2) ./ ( C_add_c(:, 1) .* (lambda + Tdelay));
PI_Ti_add = C_add_c(:, 2);

PI_kp_rec = C_rec_c(:, 2) ./ ( C_rec_c(:, 1) .* (lambda + Tdelay));
PI_Ti_rec = C_rec_c(:, 2);

T_sim = 100;

% For main:
for j = 1:length(PI_kp_main)
    figure;
    for i = 1:size(C_main, 1)
        [t, u, y] = ModelSimulation(PI_kp_main(j), PI_Ti_main(j), C_main(i, :), T_sim, Ts);
        
        % Check overshoot for SP = 1:
        if (max(y) > 2)
            disp(['Main: PI ', num2str(j), ' discarded for overshoot over 100%!']);
            continue;
        else
            subplot(2, 1, 1);
            hold on;
            stairs(t, y);
            subplot(2, 1, 2);
            hold on;
            stairs(t, u);
        end
    end
    subplot(2, 1, 1);
    title(['Main - PI parameters set ', num2str(j)]);
    ylabel('system step response');
    subplot(2, 1, 2);
    xlabel('time, s');
    ylabel('system control value');
end

% For add:
for j = 1:length(PI_kp_add)
    figure;
    for i = 1:size(C_add, 1)
        [t, u, y] = ModelSimulation(PI_kp_add(j), PI_Ti_add(j), C_add(i, :), T_sim, Ts);
        
        % Check overshoot for SP = 1:
        if (max(y) > 2)
            disp(['Add: PI ', num2str(j), ' discarded for overshoot over 100%!']);
            continue;
        else
            subplot(2, 1, 1);
            hold on;
            stairs(t, y);
            subplot(2, 1, 2);
            hold on;
            stairs(t, u);
        end
    end
    subplot(2, 1, 1);
    title(['Add - PI parameters set ', num2str(j)]);
    ylabel('system step response');
    subplot(2, 1, 2);
    xlabel('time, s');
    ylabel('system control value');
end

% For rec:
for j = 1:length(PI_kp_rec)
    figure;
    for i = 1:size(C_rec, 1)
        [t, u, y] = ModelSimulation(PI_kp_rec(j), PI_Ti_rec(j), C_rec(i, :), T_sim, Ts);
        
        % Check overshoot for SP = 1:
        if (max(y) > 2)
            disp(['Rec: PI ', num2str(j), ' discarded for overshoot over 100%!']);
            continue;
        else
            subplot(2, 1, 1);
            hold on;
            stairs(t, y);
            subplot(2, 1, 2);
            hold on;
            stairs(t, u);
        end
    end
    subplot(2, 1, 1);
    title(['Rec - PI parameters set ', num2str(j)]);
    ylabel('system step response');
    subplot(2, 1, 2);
    xlabel('time, s');
    ylabel('system control value');
end