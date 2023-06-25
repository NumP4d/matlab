clear;
close all;
clc;

T_sim   = 100;

% Controller timing parameters
Tc              = 0.01;
time_controller = 0:Tc:T_sim;
N_sampling      = 10;
% Simulation timing parameters
Ts      = Tc / N_sampling;
time    = 0:Ts:T_sim;

% Initial conditions
xi =    0;
qi =    0;
ui =    0;
y0 =    0;

% Storage vectors
x = xi;
q = qi;
u = ui;
y = y0;

% Plant parameters setup
Vm = 3;
Vd = 2;

% Controller setup
d  = 2;
Tp = 1;
Tpold = Tp;
modi = 1;

Tp_c = Tp;

wi = 0;
w = wi;
sum_e = 0;

for i = 1:(length(time_controller)-1)

    qi = 2;
    if (time_controller(i) > 40)
        qi = 3;
    end
    if (time_controller(i) > 60)
        qi = 1.2;
    end
    qi = 2 * sin(0.1 * time_controller(i)) + 4;
    q = [q, qi];
    
    k = 1;
    T = Vm / qi;
    Delay = Vd / qi;
    [A, B, C, D] = TranslateModel(k, T);
    
    for j = 1:N_sampling
        [xi, yi] = Plant(xi, u, A, B, C, D, Delay, Ts);
        % Save plant state and output
        x = [x, xi];
        y = [y, yi];
    end
    
    if (mod(time_controller(i), 40) == 0)
        wi = wi + 1;
    elseif (mod(time_controller(i), 40) == 20)
        wi = wi - 1;
    end
    
    w = [w, wi];
    
    % Variable Sampling time controller
    if (mod(i, ceil(Tp / Tc)) == modi)
        kr = 1 / Tp * 0.2;
        e = wi - yi;
        ui = ui + kr * e;
        Tpold = Tp;
        % Set new sampling time
        Tp = Vd / (d * qi);
        modi = mod(i, ceil(Tp / Tc));
    end

    Tp_c = [Tp_c, ceil(Tp / Tc)];
    
    % Save controller state
    u = [u, ui];
end

% Plot results
figure;
subplot(3, 1, 1);
plot(time, y);
grid on;
hold on;
stairs(time_controller, w, 'r');
ylabel('c(t)');
legend('PV', 'SP');
subplot(3, 1, 2);
stairs(time_controller, u);
ylabel('cin(t)');

grid on;
subplot(3, 1, 3);
stairs(time_controller, q);
grid on;
%ylim([1, 7]);
ylabel('Q(s)');
xlabel('time, s');

figure;
subplot(2, 1, 1);
stairs(time_controller, Tp_c);
grid on;
ylim([15, 55]);
ylabel('Tp(t)');
subplot(2, 1, 2);
stairs(time_controller, q);
grid on;
%ylim([1, 7]);
ylabel('Q(t)');
xlabel('time, s');