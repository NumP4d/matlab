clear;
close all;
clc;

wektor_e = randn(1001, 1);

for h = 1:2

T_sim   = 1000;
Tchange = 400;

% Controller timing parameters
Tc              = 1;
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

% Storage vectors
x = xi;
u = ui;
y = y0;
% Prediction of output
y_p = y0;
% Controller viewable y
y_c = y0;

% 2nd order inertia
k  = 3;
T1 = 1;
T2 = 2;
Delay = 0;
[A, B, C, D] = TranslateModel(k, T1, T2);

w = 0;
w_c = w;

% APZP:
nS = 1;
nR = 1;

alfa_PZP = 0;   % AmAo = 1 for minimum variance control
beta_PZP = 0.95;

alfa_PZP_RLS = 1;

AmAo = [1, alfa_PZP];

Km_PZP = (1 + alfa_PZP) / (1 + beta_PZP);

% Direct RLS parameters
bi_PZP = zeros(2 + nS + nR, 1);
bi_PZP(1) = 1;
Pi_PZP = diag(100 * ones(length(bi_PZP), 1));

bi_c = bi_PZP;

% ARMAX model setting
nB = 1;
nA = 2;
nC = 1;
C_e = [1;
     -0.5] * 3;
delModel = 1;

% % Calculate transfer function parameters
s = tf('s');
Ks = k / (1 + T1*s) / (1 + T2*s);
Kd = c2d(Ks, Tc);
Kf = filt(Kd.Numerator, Kd.Denominator);
b = cell2mat(Kf.Numerator);
a = cell2mat(Kf.Denominator);
b_c2d = [b(2:end), a(2:end)]';
 
bi_e = [C_e;
        a(2:end)'];

% Storage vectors for error path model
e = 0;
y_e = 0;

% Controller setup
sum_e       = 0;
SP          = 0;
kcontrol    = 0.8;
Ticontrol   = 3;

% Variance calculation Setting:
nVar = 100;

var_c = zeros(1, nVar+1);

run = 1;

if (run == 1)
    nerw = 10;
for i = 1:(length(time_controller)-1)
    
    if (i == nerw * round((length(time_controller)-1) / 100))
        disp([num2str(nerw), '%']);
        nerw = nerw + 10;
    end
    
    % Generate fi for PZP
    [fi_PZP] = GenerateFi(u, -y_c, delModel, nR, nS + 1);
    % After steady state update model parameters
    if (time_controller(i) >= Tchange)
%             kn = 0.5 * k * (time((i-1) * N_sampling + j) - Tchange) + k;
%             T1n = T1;
%             T2n = T2;
%         [A, B, C, D] = TranslateModel(kn, T1n, T2n);
%         s = tf('s');
%         Ks = kn / (1 + T1n*s) / (1 + T2n*s);
%         Kd = c2d(Ks, Tc);
%         Kf = filt(Kd.Numerator, Kd.Denominator);
%         b = cell2mat(Kf.Numerator);
%         a = cell2mat(Kf.Denominator);
%         b_c2d = [b(2:end), a(2:end)]';
%         bi_e = [C_e;
%                 a(2:end)'];
          %bi_e(1:2) = bi_e(1:2) * 1.01;
    end
    for j = 1:N_sampling
        if (time((i-1) * N_sampling + j) >= Tchange)
%             kn = 0.5 * k * (time((i-1) * N_sampling + j) - Tchange) + k;
%             T1n = T1;
%             T2n = T2;
% 
%             [A, B, C, D] = TranslateModel(kn, T1n, T2n);
        end
        [xi, yi] = Plant(xi, u, A, B, C, D, Delay, Ts, Tc);
        % Save plant state and output
        x = [x, xi];
        y = [y, yi];
    end
    % Generate error path from ARMAX:
    %ei = 1 * randn();
    ei = wektor_e(i);
    e = [e, ei];
    fi_e = GenerateFi(e, y_e, 1, nC, nA);
    yi_e = ModelPlant(fi_e, bi_e);
    y_e = [y_e, yi_e];
    yi = yi + yi_e;
    %yi = yi + ei;
    y_c = [y_c, yi];
    
    w_c = [w_c, w];
    
    % Filter AmAo
    % Gamma is directly output
    gamma = yi;
    
    [bi_PZP, Pi_PZP] = RLS_Plant(fi_PZP, gamma, bi_PZP, Pi_PZP, alfa_PZP_RLS);
    
    % Save parameters
    bi_c = [bi_c, bi_PZP];

    if (h == 1)
        [ui] = AdaptablePoleZerosPlacementController(u, y_c, w_c, bi_PZP, beta_PZP, Km_PZP, nR);
    else
        [ui, sum_e] = Controller(SP, yi, sum_e, kcontrol, Ticontrol, Tc);
        ui = 0;
    end
    
    % Save controller state
    u = [u, ui];
    
    if (i > nVar)
        var_c = [var_c, var(y_c((end-100):end))];
    end
end

disp(bi_PZP);

% Plot results
if (h == 1)
    figure;
end
subplot(3, 1, 1);
hold on;
plot(time_controller, y_c);
grid on;
ylabel('y(t)');
subplot(3, 1, 2);
hold on;
stairs(time_controller, u);
grid on;
ylabel('u(t)');
subplot(3, 1, 3);
hold on;
stairs(time_controller, var_c);
grid on;
ylabel('variance');



% figure;
% stairs(time_controller, sum(bi_c, 1), 'k--');
% hold on;
% stairs(time_controller, bi_c(1, :));
% stairs(time_controller, bi_c(2, :));
% stairs(time_controller, bi_c(3, :));
% stairs(time_controller, bi_c(4, :));
% grid on;

end

end
if (h == 2)
subplot(3, 1, 1);
legend('minvar', 'PI');

subplot(3, 1, 2);
legend('minvar', 'PI');

subplot(3, 1, 3);
legend('minvar', 'PI');
end
subplot(3, 1, 3);
xlim([nVar, time_controller(end)]);