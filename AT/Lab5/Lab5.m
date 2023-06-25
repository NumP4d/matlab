clear;
close all;
clc;
%alfa_pole = [-0.9 -0.3 0.00011 0.25 0.5 0.7 0.95];

alfa_pole = -0.9;
%alfa_pole = 0;
%alfa_pole = -0.3679;
%alfa_pole = -0.99;
%alfa_pole = -0.99;

for m = 1:length(alfa_pole)
T_sim   = 100;
Tchange = 40;
%Tchange = 1.8;

% Controller timing parameters
Tc              = 0.5;
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
%Pi = 0;
alpha = 0.9;
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
%bi_c = bi;

% 2nd order inertia
k  = 3;
T1 = 1;
T2 = 2;
Delay = 0;
[A, B, C, D] = TranslateModel(k, T1, T2);

% Controller setup
sum_e       = 0;
SP          = 7;
kcontrol    = 0.8;
Ticontrol   = 3;

w = 1;
w_c = [0];
%alfa_pole = 0.9;
%[R, T, S] = PoleControllerInit(k, T1, T2, Tc, alfa_pole(m));
%[R, T, S] = PoleControllerInit(k, T1, T2, Tc, alfa_pole(m));

% U saturation
uimax = 10;
uimin = -10;

% APZP:
nS = 1;
nR = 2;

alfa_PZP = -0.3679;
%beta_PZP = -0.3;
%beta_PZP = -0.95;
%beta_PZP = 0.95;
beta_PZP = 0.99;
%beta_PZP = 0.3;

alfa_PZP_RLS = 0.8;

AmAo = [1, alfa_PZP];

Km_PZP = (1 + alfa_PZP) / (1 + beta_PZP);

% Direct RLS parameters
bi_PZP = zeros(2 + nS + nR, 1);
bi_PZP(1) = 1;
Pi_PZP = diag(100 * ones(length(bi_PZP), 1));
%Pi = 0;

% beta = [-30, -0.9, -0.75, -0.4, -0.2, 0, 0.1, 0.5, 0.9, 1, 50];
% figure;
% grid on;
% hold on;
% for i = 5:length(beta)
%     Km = (1 + alfa_PZP) / (1 + beta(i));
%     [h, w] = freqz(Km * [1, beta(i)], AmAo, 4096);
%     plot(w, abs(h));
%     string{i} = num2str(beta(i));
% end
% xlim([w(1), w(end)]);
% xlabel('Normalized frequency rad/sample');
% ylabel('|H(z)|');
% legend(string{5}, string{6}, string{7}, string{8}, string{9}, string{10}, string{11});

[R, T, S] = PoleControllerInit(k, T1, T2, Tc, alfa_PZP, beta_PZP);

bi_c = bi_PZP;

gamma_c = [];

run = 1;

if (run == 1)
for i = 1:(length(time_controller)-1)
    % After steady state update model parameters
    if (time_controller(i) >= Tchange)
%         kn = k * 5;
%         T1n = T1 * 0.2;
%         T2n = T2 * 0.03;
%         SP = 14;
%         [A, B, C, D] = TranslateModel(kn, T1n, T2n);
%         kn = 0.5 * k * (time_controller(i) - Tchange) + k;
%         T1n = T1;
%         T2n = T2;
%         SP = 14;
%         [A, B, C, D] = TranslateModel(kn, T1n, T2n);
    end
    
    % Generate fi vector
    [fi] = GenerateFi(u, y_c, delModel, nB, nA);
    
    [fi_PZP] = GenerateFi(u, -y_c, delModel, nR, nS + 1);
    
    y_pi = ModelPlant(fi, bi);
    % Save prediction
    y_p = [y_p, y_pi];
    
    for j = 1:N_sampling
        if (time((i-1) * N_sampling + j) >= Tchange)
    %         kn = k * 5;
    %         T1n = T1 * 0.2;
    %         T2n = T2 * 0.03;
    %         SP = 14;
    %         [A, B, C, D] = TranslateModel(kn, T1n, T2n);
            kn = 0.5 * k * (time((i-1) * N_sampling + j) - Tchange) + k;
            T1n = T1;
            T2n = T2;
            SP = 14;
            [A, B, C, D] = TranslateModel(kn, T1n, T2n);
        end
        [xi, yi] = Plant(xi, u, A, B, C, D, Delay, Ts, Tc);
        % Save plant state and output
        x = [x, xi];
        y = [y, yi];
    end
    ei = 0.05 * randn();
    %yi = yi + ei;
    y_c = [y_c, yi];
    
    % Filter AmAo
    gamma = FIR(AmAo, y_c);
    
    [bi_PZP, Pi_PZP] = RLS_Plant(fi_PZP, gamma, bi_PZP, Pi_PZP, alfa_PZP_RLS);
    
    gamma_c = [gamma_c, gamma];
   
    if (mod(time_controller(i), 20) == 0)
        w = w + 1;
    elseif (mod(time_controller(i), 20) == 10)
        w = w - 1;
    end
    w_c = [w_c, w];
    
   [bi, Pi] = RLS_Plant(fi, yi, bi, Pi, alpha);
    % Save parameters
    %bi_c = [bi_c, bi];
    bi_c = [bi_c, bi_PZP];

    if (time_controller(i) >= 5)
        %ui = PoleControllerAdaptable(u, y_c, w, bi, alfa_pole(m));
        %[ui, sum_e] = Controller(w, yi, sum_e, kcontrol, Ticontrol, Tc);
        bi_PZP_const = [R'; S'];
        %[ui] = AdaptablePoleZerosPlacementController(u, y_c, w_c, bi_PZP_const, beta_PZP, Km_PZP, nR);
        [ui] = AdaptablePoleZerosPlacementController(u, y_c, w_c, bi_PZP, beta_PZP, Km_PZP, nR);
        %ui = 5 * sin(2 * time_controller(i)) + 3 * sin(10 * time_controller(i));
    else
        ui = 5 * sin(2 * time_controller(i)) + 3 * sin(10 * time_controller(i));
    end
    
    %ui = 5 * randn(1, 1);
    
%     % Saturate ui
%     if (ui > uimax)
%         ui = uimax;
%     elseif (ui < uimin)
%         ui = uimin;
%     end

    % Save controller state
    u = [u, ui];
end

% % Calculate final transfer function parameters
s = tf('s');
Ks = k / (1 + T1*s) / (1 + T2*s);
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
%stairs(time_controller, w_c, 'r');
grid on;
hold on;
plot(time, y, 'b');
stairs(time_controller, y_p, 'g');
stairs(time_controller, w_c, 'r');
subplot(3, 1, 2);
stairs(time_controller, u);
grid on;
subplot(3, 1, 3);
stairs(time_controller, sum(bi_c, 1), 'k--');
hold on;
stairs(time_controller, bi_c(1, :));
stairs(time_controller, bi_c(2, :));
stairs(time_controller, bi_c(3, :));
stairs(time_controller, bi_c(4, :));
stairs(time_controller, bi_c(5, :));
grid on;

figure;
stairs(time_controller(1:end-1), gamma_c);

end

end