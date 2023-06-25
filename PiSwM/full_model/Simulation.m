clear;
close all;
clc;

% Car parameters
mr    = 580 * 2;     % kg
Jp    = 1039;        % kgm^2
l1p   = 0.99;        % m
l2p   = 1.81;        % m
Jr    = 780;         % kgm^2
l1r   = 0.9;         % m
l2r   = 0.9;         % m
mnr11 = 60;          % kg
kr11  = 15 * 1000;   % N/m
knr11 = 200 * 1000;  % N/m
C11   = 1185;        % Ns/m
mnr21 = 60;          % kg
kr21  = 14 * 1000;   % N/m
knr21 = 200 * 1000;  % N/m
C21   = 1185;        % Ns/m
mnr12 = 60;          % kg
kr12  = 15 * 1000;   % N/m
knr12 = 200 * 1000;  % N/m
C12   = 1185;        % Ns/m
mnr22 = 60;          % kg
kr22  = 14 * 1000;   % N/m
knr22 = 200 * 1000;  % N/m
C22   = 1185;        % Ns/m
g     = 9.81;        % m/s2

% Vechicle speed:
v_vech = 5;         % km/h

% Damper parameter
C = 1185; % Ns/m
    
% Simulation parameters
t_sim = 20;
Ts = 0.001;

t = 0:Ts:t_sim;

% Create vectors
xr  = zeros(size(t));
vr  = zeros(size(t));
fi  = zeros(2, length(t));
w   = zeros(2, length(t));
xrt = zeros(2, 2, length(t));
vrt = zeros(2, 2, length(t));
xnr = zeros(2, 2, length(t));
vnr = zeros(2, 2, length(t));
Ft  = zeros(2, 2, length(t));

% Initial conditions
%Psteady = [mr, mnr1, kr1, knr1, l1, mnr2, kr2, knr2, l2, g];
%[xr(1), fi(1), xnr1(1), xnr2(1)] = InitialConditions(Psteady);

% Create road vectors
Pcopy = [Ts, l1p, l2p, v_vech];
x011    = ones(size(t)) * 0.2;
x011(1) = 0;
x011(length(t)/2:end) = 0;
x021 = CopyInput(Pcopy, x011);

Pcopy = [Ts, l1p, l2p, v_vech];
x012    = zeros(size(t)) * 0.2;
x012(1) = 0;
x012(length(t)/2:end) = 1;
x022 = CopyInput(Pcopy, x012);

x0 = zeros(2, 2, length(t));
x0(1, 1, :) = x011;
x0(1, 2, :) = x012;
x0(2, 1, :) = x021;
x0(2, 2, :) = x022;

% Create Vectored parameters
Pfull = [Ts, mr, Jp, Jr, kr11, l1p, kr21, l2p, kr12, l1r, kr22, l2r, g];
Pnr11 = [Ts, mnr11, kr11, knr11, g];
Pnr12 = [Ts, mnr12, kr12, knr12, g];
Pnr21 = [Ts, mnr21, kr21, knr21, g];
Pnr22 = [Ts, mnr22, kr22, knr22, g];
Pmov  = [l1p, l2p, l1r, l2r];

for i = 1:length(t)
    [vrt(:, :, i), xrt(:, :, i)] = TranslateMovement(Pmov, vr(i), xr(i), w(:, i), fi(:, i));
    Ft(:, :, i) = ConventionalDamper(C, vrt(:, :, i), vnr(:, :, i));
    if (i < length(t))
        [vnr(1, 1, i+1), xnr(1, 1, i+1)] = nr_model(Pnr11, vnr(1, 1, i), xnr(1, 1, i), xrt(1, 1, i), x0(1, 1, i), Ft(1, 1, i));
        [vnr(1, 2, i+1), xnr(1, 2, i+1)] = nr_model(Pnr12, vnr(1, 2, i), xnr(1, 2, i), xrt(1, 2, i), x0(1, 2, i), Ft(1, 2, i));
        [vnr(2, 1, i+1), xnr(2, 1, i+1)] = nr_model(Pnr21, vnr(2, 1, i), xnr(2, 1, i), xrt(2, 1, i), x0(2, 1, i), Ft(2, 1, i));
        [vnr(2, 2, i+1), xnr(2, 2, i+1)] = nr_model(Pnr22, vnr(2, 2, i), xnr(2, 2, i), xrt(2, 2, i), x0(2, 2, i), Ft(2, 2, i));
        [vr(i+1), xr(i+1), w(:, i+1), fi(:, i+1)] = full_model(Pfull, vr(i), xr(i), w(:, i), fi(:, i), xnr(:, :, i), Ft(:, :, i), xrt(:, :, i));
    end
end

for i = 1:2
    for j = 1:2
        figure;
        subplot(3, 1, 1);
        plot(t, reshape(x0(i, j, :), size(t)));
        ylabel(['x0 ', num2str(i), num2str(j), ', m']);
        subplot(3, 1, 2);
        plot(t, reshape(xnr(i, j, :), size(t)));
        ylabel(['xnr ', num2str(i), num2str(j), ', m']);
        subplot(3, 1, 3);
        plot(t, reshape(xrt(i, j, :), size(t)));
        ylabel(['xrt ', num2str(i), num2str(j), ', m']);
        
        xlabel('time, s');
    end
end

figure;
subplot(3, 1, 1);
plot(t, xr);
ylabel('xr, m');
subplot(3, 1, 2);
plot(t, reshape(fi(1, :), size(t)));
ylabel('fip, rad');
subplot(3, 1, 3);
plot(t, reshape(fi(2, :), size(t)));
ylabel('fir, rad');

xlabel('time, s');