close all;
% DO NOT CLEAR
clc;

N = length(y_add_p) + 1;

    figure;
    subplot(3, 1, 1);
    plot(t(2:N), u_main(2:N), 'b');
    hold on;
    grid on;
    ylabel('x SP, %');
    subplot(3, 1, 2);
    plot(t(2:N), y_main(2:N), 'b');
    hold on;
    grid on;
    plot(t(2:N), y_main_p(1:N-1), 'r--');
    legend('measurement', 'model');
    ylabel('v, m/s');
    subplot(3, 1, 3);
    plot(t(2:N), sum(bi_main_c(:, 1:N-1)));
    ylabel('sum of parameters');
    xlabel('time, s');
    
    figure;
    subplot(3, 1, 1);
    plot(t(2:N), u_rec(2:N), 'b');
    hold on;
    grid on;
    ylabel('x SP, %');
    subplot(3, 1, 2);
    plot(t(2:N), y_rec(2:N), 'b');
    plot(t(2:N), y_rec_p(1:N-1), 'r');
    legend('measurement', 'model');
    ylabel('v, m/s');
    subplot(3, 1, 3);
    plot(t(2:N), bi_rec_c(:, 1:N-1));
    ylabel('sum of parameters');
    xlabel('time, s');

    figure;
    subplot(3, 1, 1);
    plot(t(2:N), u_add(2:N), 'b');
    hold on;
    grid on;
    ylabel('x SP, %');
    subplot(3, 1, 2);
    plot(t(2:N), y_add(2:N), 'b');
    plot(t(2:N), y_add_p(1:N-1), 'r');
    legend('measurement', 'model');
    ylabel('v, m/s');
    subplot(3, 1, 3);
    plot(t(2:N), bi_add_c(:, 1:N-1));
    ylabel('sum of parameters');
    xlabel('time, s');