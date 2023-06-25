clear;
close all;
clc;

T_sim   = 10;
Tchange = 50;
%Tchange = 1.8;

% Controller timing parameters
Tc              = 0.1;
time_controller = 0:Tc:T_sim;
N_sampling      = 100;
% Simulation timing parameters
Ts      = Tc / N_sampling;
time    = 0:Ts:T_sim;

% Initial conditions
xi = [  0;
        0];
ui =    0;
y0 =    0;

% ARX model setting
nB = 1;
nA = 2;
delModel = 1;

% Initial for RLS algorithm
%bi = zeros(delModel + nB + nA, 1);
%bi = [0.007136; 0.006788; -1.856; 0.8607];
bi = zeros(1 + nB + nA, 1);
bi(1) = 1;
Pi = diag(100 * ones(length(bi), 1));
alpha = 1;
disp(Pi)

b_c2d = [3.2171;
    1.5702;
   -0.7954;
    0.1146];

% Storage vectors
x = xi;
u = ui;
y = y0;
% Prediction of output
y_p = y0;
% Controller viewable y
y_c = y0;
% Vector parameters estimated
bi_c = bi;

% 2nd order inertia
k  = 3;
T1 = 1;
T2 = 2;
kn = k;
T1n = T1;
T2n = T2;
Delay = 0;
[A, B, C, D] = TranslateModel(k, T1, T2);

% Controller setup
sum_e       = 0;
SP          = 7;
kcontrol    = 0.8;
Ticontrol   = 3;

for i = 1:(length(time_controller)-1)
    % After steady state update model parameters
    if (time_controller(i) >= Tchange)
        kn = k * 5;
        T1n = T1 * 0.2;
        T2n = T2 * 0.03;
        SP = 14;
        [A, B, C, D] = TranslateModel(kn, T1n, T2n);
    end
    
    % Generate fi vector
    [fi] = GenerateFi(u, y_c, delModel, nB, nA);
    
    y_pi = ModelPlant(fi, bi);
    % Save prediction
    y_p = [y_p, y_pi];
    
    for j = 1:N_sampling
        [xi, yi] = Plant(xi, u, A, B, C, D, Delay, Ts, Tc);
        % Save plant state and output
        x = [x, xi];
        y = [y, yi];
    end
    ei = 0.25 * randn();
    %yi = yi + ei;
    y_c = [y_c, yi];
    ui = 1;
    if (mod(time_controller(i), 4) == 0)
        ui = ui + 1;
    elseif (mod(time_controller(i), 4) == 2)
        ui = ui - 1;
    end
    ui = 5 * sin(2 * time_controller(i)) + 3 * sin(10 * time_controller(i));
    % Save controller statememe white gives hand to african gif white hands
    u = [u, ui];
    [bi, Pi] = RLS_Plant(fi, yi, bi, Pi, alpha);
    % Save parameters
    bi_c = [bi_c, bi];
    %[ui, sum_e] = Controller(SP, yi, sum_e, kcontrol, Ticontrol, Tc);
    %[ui, sum_e, kcontrol] = AdaptiveController(SP, yi, sum_e, kcontrol, Ticontrol, Tc);
end

% Calculate final transfer function parameters
s = tf('s');
Ks = kn / (1 + T1n*s) / (1 + T2n*s);
Kd = c2d(Ks, Tc);
Kf = filt(Kd.Numerator, Kd.Denominator);
b = cell2mat(Kf.Numerator);
a = cell2mat(Kf.Denominator);
b_c2d = [b(2:end), a(2:end)]';
disp(bi);
disp(b_c2d);

% Plot results
figure;
subplot(3, 1, 1);
plot(time, y());
ylabel('y(t)');
grid on;
hold on;
plot(time_controller, y_c, 'b.');
stairs(time_controller, y_p);
legend('plant', 'measurements', 'calculated', 'location', 'best');
subplot(3, 1, 2);
stairs(time_controller, u);
ylabel('u(t)');
grid on;
subplot(3, 1, 3);
stairs(time_controller, sum(bi_c, 1));
ylabel('Sum of bi');
xlabel('time');
grid on;