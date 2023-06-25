clear;
close all;
clc;

T_sim   = 100;
Tchange = 140;
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

% Storage vectors
x = xi;
u = ui;
y = y0;
% Controller viewable y
y_c = y0;
B_Relay = 10;

% 2nd order inertia
k  = 3;
T1 = 1;
T2 = 2;
kn = k;
T1n = T1;
T2n = T2;
Delay = 0;
[A, B, C, D] = TranslateModel(k, T1, T2);

% Filter construction
N_filt = 31;
Wn = 0.0001;
% Lowpass filter
B_filt = fir1(N_filt, Wn);
y_filt = 0;

u_filt = 0;

y_steady = 0;
horizon = 20;
eps = 0.01;
time_first = 0;

% Relay autotuning setup
t_zero = [];
y_zero = [];
y_amp = [];
tuned = 0;

% Controller setup
sum_e      = 0;
SP0        = 14;
SP         = SP0;

w = SP0;

for i = 1:(length(time_controller)-1)
    
    if (time_controller(i) > Tchange)
        SP = 3;
    end

    for j = 1:N_sampling
        [xi, yi] = Plant(xi, u, A, B, C, D, Delay, Ts, Tc);
        % Save plant state and output
        x = [x, xi];
        y = [y, yi];
    end
    ei = 0.5 * randn();
    %yi = yi + ei;
    y_c = [y_c, yi];
    
    y_filt = [y_filt, FIR(B_filt, y_c)];
    u_filt = [u_filt, FIR(B_filt, u)];
    
    % Find settled oscillations
    if (i >= horizon)
        if (var(y_filt(end-horizon:end)) < eps)
            y_steady = [y_steady, y_filt(end)];
            if (time_first == 0)
                time_first = time_controller(i);
                steady_first = mean(y_filt(end-horizon:end));
            end
        else
            y_steady = [y_steady, 0];
        end
    end
    
    if (time_first ~= 0)
        if (length(t_zero) < 3)
            % Stepped through zero (steady value)
            if (sign((y_c(end) - SP) * (y_c(end-1) - SP)) == -1)
                t_zero = [t_zero, time_controller(i)];
            end
            if (length(t_zero) < 3)
                y_zero = [y_zero, yi];
            end
            if (length(t_zero) == 3)
                %Amp_osc = max(abs(y_zero - steady_first));
                Amp_osc = 0.5 * (max(y_zero) - min(y_zero));
                T_osc = t_zero(3) - t_zero(1);
                
                kgr = 8 * Amp_osc ./ (pi .* B_Relay);
                %kgr = 4 * B_Relay ./ (pi .* Amp_osc);
                %kgr = 1 ./ kgr;
                kcontrol    = 0.9 * kgr;
                Ticontrol   = 1.2 * T_osc;
                % Bumpless operation for PI:
                sum_e = (u_filt(end) ./ kcontrol - (SP - yi)) .* Ticontrol;
                tuned = 1;
            end
        end
    end
    
    if (tuned == 1)
        if (mod(time_controller(i), 40) == 0)
            SP = SP0;
        elseif (mod(time_controller(i), 40) == 20)
            SP = -SP0;
        end
    end
    
    w = [w, SP];
    
    if (tuned == 0)
        ui = RelayController(SP, yi, B_Relay);
    else
        [ui, sum_e] = Controller(SP, yi, sum_e, kcontrol, Ticontrol, Tc);
    end
    
    % Save controller statememe white gives hand to african gif white hands
    u = [u, ui];
end

% Plot results
figure;
subplot(2, 1, 1);
plot(time, y());
ylabel('y(t)');
grid on;
hold on;
stairs(time_controller, y_c, 'b');

stairs(time_controller(time_controller <= t_zero(3)), y_filt(time_controller <= t_zero(3)), 'r');

%plot([time_controller(1), time_controller(end)], [steady_first, steady_first], 'r--');
plot([time_first-0.001, time_first+0.001], [-20, +20], 'k--');

plot([t_zero(3)-0.001, t_zero(3)+0.001], [-20, +20], 'k--');

%stairs(time_controller(horizon:end), y_steady, 'k--');

stairs(time_controller, w, 'k');
%legend('plant', 'measurements', 'calculated', 'location', 'best');

% subplot(3, 1, 2);
% % Calculate FFT from steady state point
% fft_steady = abs(fft(y_c(time_first:end) - steady_first));
% fft_steady = fft_steady(1:end/2);
% 
% plot(fft_steady);
% grid on;
% hold on;

subplot(2, 1, 2);
stairs(time_controller, u);
ylabel('u(t)');
grid on;
hold on;
stairs(time_controller(time_controller <= t_zero(3)), u_filt(time_controller <= t_zero(3)), 'r');
plot([t_zero(3)-0.001, t_zero(3)+0.001], [-20, +20], 'k--');