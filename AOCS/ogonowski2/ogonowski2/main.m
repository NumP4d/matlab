clear all
close all
clc

x = load('AoCS_EMM.mat');

Ts = 0.2;

t = 0:Ts:(Ts*length(x.x_main_SP) - Ts)';

u_main = x.x_main_SP;
u_rec = x.x_rec_SP;
u_add = x.x_add1_SP;

y_main = x.v_main;
y_rec = x.v_rec;
y_add = x.v_add1;

    przedzial = 1:length(t);

    figure;
    subplot(2, 1, 1);
    plot(t(przedzial), u_main(przedzial));
    hold on;
    grid on;
    plot(t(przedzial), u_rec(przedzial));
    plot(t(przedzial), u_add(przedzial));
    legend('main', 'rec', 'add');
    ylabel('x SP, %');
    subplot(2, 1, 2);
    plot(t(przedzial), y_main(przedzial));
    hold on;
    grid on;
    plot(t(przedzial), y_rec(przedzial));
    plot(t(przedzial), y_add(przedzial));
    legend('main', 'rec', 'add');
    xlabel('time, s');
    ylabel('v, m/s');
    
ADD_STEP_LENGTH = length(t) ./ 90;
REC_STEP_LENGTH = length(t) ./ 10;

% for i = 1:90
%     przedzial = int32(((i-1) * ADD_STEP_LENGTH + 1):(i * ADD_STEP_LENGTH));
%     
%     figure;
%     subplot(2, 1, 1);
%     plot(t(przedzial), u_main(przedzial));
%     hold on;
%     grid on;
%     plot(t(przedzial), u_rec(przedzial));
%     plot(t(przedzial), u_add(przedzial));
%     legend('main', 'rec', 'add');
%     ylabel('x SP, %');
%     subplot(2, 1, 2);
%     plot(t(przedzial), y_main(przedzial));
%     hold on;
%     grid on;
%     plot(t(przedzial), y_rec(przedzial));
%     plot(t(przedzial), y_add(przedzial));
%     legend('main', 'rec', 'add');
%     xlabel('time, s');
%     ylabel('v, m/s');
% end

% ARX model settingn
nB = 1;
nA = 2;
delModel = 1;

alpha = 0.98;
% Initial for RLS algorithm
bi_main = zeros(1 + nB + nA, 1);
bi_main(1) = 1;
Pi_main = diag(100 * ones(length(bi_main), 1));

y_main_p = [];
bi_main_c = bi_main;

bi_rec = zeros(1 + nB + nA, 1);
bi_rec(1) = 1;
Pi_rec = diag(100 * ones(length(bi_rec), 1));

y_rec_p = [];
bi_rec_c = bi_rec;

bi_add = zeros(1 + nB + nA, 1);
bi_add(1) = 1;
Pi_add = diag(100 * ones(length(bi_add), 1));

y_add_p = [];
bi_add_c = bi_add;

for i = 2:length(t)
    
    if (mod(i, round((length(t) - 1) ./ 1000)) == 0)
        disp([num2str(i / round(length(t) - 1) * 100), ' % ...']);
    end
    % Generate fi vectors
    fi_main = GenerateFi(u_main(1:(i-1)), y_main(1:(i-1)), delModel, nB, nA);
    y_main_pi = ModelPlant(fi_main, bi_main);    
    y_main_p = [y_main_p, y_main_pi];    
    [bi_main, Pi_main] = RLS_Plant(fi_main, y_main(i), bi_main, Pi_main, alpha);    
    % Save parameters    
    bi_main_c = [bi_main_c, bi_main];
    % Generate fi vectors
    fi_rec = GenerateFi(u_rec(1:(i-1)), y_rec(1:(i-1)), delModel, nB, nA);
    y_rec_pi = ModelPlant(fi_rec, bi_rec);    
    y_rec_p = [y_rec_p, y_rec_pi];    
    [bi_rec, Pi_rec] = RLS_Plant(fi_rec, y_rec(i), bi_rec, Pi_rec, alpha);    
    % Save parameters    
    bi_add_c = [bi_add_c, bi_add];
    % Generate fi vectors
    fi_add = GenerateFi(u_add(1:(i-1)), y_add(1:(i-1)), delModel, nB, nA);
    y_add_pi = ModelPlant(fi_add, bi_add);    
    y_add_p = [y_add_p, y_add_pi];    
    [bi_add, Pi_add] = RLS_Plant(fi_add, y_add(i), bi_add, Pi_add, alpha);    
    % Save parameters    
    bi_add_c = [bi_add_c, bi_add];
end

    figure;
    subplot(3, 1, 1);
    plot(t(2:end), u_main(2:end), 'b');
    hold on;
    grid on;
    ylabel('x SP, %');
    subplot(3, 1, 2);
    plot(t(2:end), y_main(2:end), 'b');
    plot(t(2:end), y_main_p, 'r');
    legend('measurement', 'model');
    ylabel('v, m/s');
    subplot(3, 1, 3);
    plot(t(2:end), sum(bi_main_c));
    ylabel('sum of parameters');
    xlabel('time, s');
