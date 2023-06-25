clear;
close all;
clc;

% Simulation time
T_sim   = 600;

% Controller timing parameters
Tc              = 1;
time_controller = 0:Tc:T_sim;
N_sampling      = 50;
% Simulation timing parameters
Ts      = Tc / N_sampling;
time    = 0:Ts:T_sim;
% Beam phase update time
T_beam    = 5;
time_beam = 0:T_beam:T_sim;

% Initial conditions
Pi = 0;
xi = 0;
ui = 0;
dxi = 0;

Vs = 0;

% Damper
Pxi = 0.001;    % to prevent NaNs
Vti = 0;
yi = 0;

Fni = 0;
Fti = 0;

xryg = 0;
phase_constr = 1;

% Beam not used before
phasei = 1;

% Storage vectors
P = Pi;
x = xi;
u = ui;
Fn = Fni;
phase = phasei;

% ARX model setting
nB = 1;
nA = 2;
delModel = 1;

% Initial for RLS algorithm
bi = zeros(1 + nB + nA, 1);
bi(1) = 1;
Pi_rls = diag(100 * ones(length(bi), 1));
alpha = 1;

y_p = [];

x_c = x;
u_c = u;
P_c = P;

bi_c = bi;

kr = 10;
wi = 0;

for i = 1:(length(time_controller)-1)
    
    % Generate fi vector
    [fi] = GenerateFi(u_c, P_c, delModel, nB, nA);
    y_pi = ModelPlant(fi, bi);
    y_p = [y_p, y_pi];
    
    for j = 1:N_sampling
        [Fni, phase_constr, xryg, xi_beam] = Construction(Fni, xi, xryg, phase_constr);
        %xi_beam = xi * 1000;
        Fni = Beam(Fni, xi_beam, phasei, Ts);    % Uncomment this to enable beam connection
        %Fti = Resistance(dxi);
        %[Pxi, Vti, yi] = Damper(Pxi, Pi, yi, Ts);
        xi = Actuator(xi, Pi, Fti, Fni, Ts);
        Pi = ControlValve(Pi, ui, Ts);

        % Save plant states and outputs
        P = [P, Pi];
        x = [x, xi];
        Fn = [Fn, Fni];
        
        % P controller for pressure:
        ui = kr * (wi - Pi);
        if (ui < 0)
            ui = 0;
        end
        if (ui > 78)
            ui = 78;
        end
    end
    
    x_c = [x_c, xi];
    u_c = [u_c, ui];
    P_c = [P_c, Pi];
    
    % Beam phase update
    if (mod(i, round(T_beam / Tc)) == 0)
        phasei = BeamPhase(Fni, phasei);
        phase = [phase, phasei];
    end

    if (mod(i, round((length(time_controller)-1) / 11)) == 0)
        wi = wi + 3 / 10;
    end
    
    if (mod(i, round((length(time_controller)-1) / 11)) == round(round((length(time_controller)-1) / 11) / 3))
        wi = wi - 3 / 10;
    end
    
    if (mod(i, round((length(time_controller)-1) / 11)) == 2 * round(round((length(time_controller)-1) / 11) / 3))
        wi = wi + 3 / 10;
    end
    
    [bi, Pi_rls] = RLS_Plant(fi, Pi, bi, Pi_rls, alpha);
    % Save parameters
    bi_c = [bi_c, bi];
    
    % Set step responses 0:10:100
    %if (mod(i, round((length(time_controller)-1) / 11)) == 0)
%     if (mod(i, round((length(time_controller)-1) / 8)) == 0)
%         ui = ui + 10;
%     end

%     ui = 10;
%     if (time_controller(i) >= 20)
%         ui = 20;
%     end
%     if (time_controller(i) >= 60)
%         ui = 30;
%     end
    
    % Save u
    u = [u, ui];
    
end

figure;
subplot(3, 1, 1);
plot(time, P);
ylabel('P, MPa');
subplot(3, 1, 2);
stairs(time_controller, u);
ylabel('u, %');
subplot(3, 1, 3);
plot(time, x * 10^(3));
hold on;
%plot(time, x * 0 + xryg, 'k--');
%plot(time, x * 0 + xryg + 6, 'k--');
ylabel('x, mm');

xlabel('time, s');

figure;
subplot(2, 1, 1);
plot(time, P, 'b');
hold on;
grid on;
stairs(time_controller(1:end-1), y_p, 'r');
subplot(2, 1, 2);
stairs(time_controller, sum(bi_c, 1), 'b');


figure;
subplot(2, 1, 1);
plot(time, Fn);
subplot(2, 1, 2);
plot(phase);