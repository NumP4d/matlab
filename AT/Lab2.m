clear;
close all;
clc;

T_sim   = 20;

% Controller timing parameters
Tc              = 0.1;
time_controller = 0:Tc:T_sim;
N_sampling      = 100;
% Simulation timing parameters
Ts      = Tc / N_sampling;
time    = 0:Ts:T_sim;

% % Simulation timing parameters
% Ts      = 0.01;
% T_sim   = 10;
% time    = 0:Ts:T_sim;
% % Controller timing parameters
% N_controller    = 100;
% Tc              = Ts * N_controller;
% time_controller = 0:Tc:T_sim;

% Initial conditions
xi = [  0;
        0];
ui =    0;
y0 =    0;

% Storage vectors
x = xi;
u = ui;
y = y0;

% 2nd order inertia
k  = 3;
T1 = 1;
T2 = 2;
[A, B, C, D] = TranslateModel(k, T1, T2);

% Controller setup
sum_e       = 0;
SP          = 7;
kcontrol    = 0.7;
Ticontrol   = 3;

for i = 1:(length(time_controller)-1)
    for j = 1:N_sampling
        [xi, yi] = Plant(xi, ui, A, B, C, D, Ts);
        % Save plant state and output
        x = [x, xi];
        y = [y, yi];
    end
    [ui, sum_e] = Controller(SP, yi, sum_e, kcontrol, Ticontrol, Tc);
    % Save controller state
    u = [u, ui];
end

% Plot results
figure;
subplot(2, 1, 1);
plot(time, y);
grid on;
subplot(2, 1, 2);
plot(time_controller, u);
grid on;