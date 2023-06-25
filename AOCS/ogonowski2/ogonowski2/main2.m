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
    
MAIN_STEP_LENGTH = length(t) ./ (25*10*9);    
ADD_STEP_LENGTH = length(t) ./ (9*10);
REC_STEP_LENGTH = length(t) ./ 10;

dAm = 2;
dBm = 1;
dm = 1;

% Modele MAIN
for i = 1:2
    przedzial = int32(((i-1) * MAIN_STEP_LENGTH + 1):(i * MAIN_STEP_LENGTH));
    y_id = y_main(przedzial);
    u_id = u_main(przedzial);
    
    figure;
    subplot(2, 1, 1);
    plot(t(przedzial), y_main(przedzial));
    subplot(2, 1, 2);
    plot(t(przedzial), u_main(przedzial));
    
    dane_ident = iddata(y_id, u_id, Ts);
    model = arx(dane_ident, [dAm dBm dm])  % identyfikuj model ARX
end

% Modele ADD
for i = 1:(10*9)
    przedzial = int32(((i-1) * ADD_STEP_LENGTH + 1):(i * ADD_STEP_LENGTH));
end

% Modele REC
for i = 1:(10)
    przedzial = int32(((i-1) * ADD_STEP_LENGTH + 1):(i * ADD_STEP_LENGTH));
end