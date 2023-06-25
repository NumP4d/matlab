clear;
close all;
clc;

% Car parameters
mr   = 580;         % kg
Jr   = 1039;        % kgm^2
l1   = 0.99;        % m
l2   = 1.81;        % m
mnr1 = 60;          % kg
kr1  = 15 * 1000;   % N/m
knr1 = 200 * 1000;  % N/m
C1   = 1185;        % Ns/m
mnr2 = 60;          % kg
kr2  = 14 * 1000;   % N/m
knr2 = 200 * 1000;  % N/m
C2   = 1185;        % Ns/m
g    = 9.81;        % m/s2

% Vechicle speed:
v_vech = 5;         % km/h

% Damper parameter
C = 1185; % Ns/m
    
% Simulation parameters
t_sim = 20;
Ts = 0.001;

t = 0:Ts:t_sim;

% Create vectors
xr   = zeros(size(t));
vr   = zeros(size(t));
fi   = zeros(size(t));
w    = zeros(size(t));
xr1  = zeros(size(t));
vr1  = zeros(size(t));
xr2  = zeros(size(t));
vr2  = zeros(size(t));
xnr1 = zeros(size(t));
vnr1 = zeros(size(t));
xnr2 = zeros(size(t));
vnr2 = zeros(size(t));
Ft1  = zeros(size(t));
Ft2  = zeros(size(t));

% Initial conditions
Psteady = [mr, mnr1, kr1, knr1, l1, mnr2, kr2, knr2, l2, g];
[xr(1), fi(1), xnr1(1), xnr2(1)] = InitialConditions(Psteady);

% Create road vectors
Pcopy = [Ts, l1, l2, v_vech];
x01    = ones(size(t)) * 0.2;
x01(1) = 0;
x01(length(t)/2:end) = 0;
x02 = CopyInput(Pcopy, x01);

% Create Vectored parameters
Pr   = [Ts, mr, Jr, kr1, l1, kr2, l2, g];
Pnr1 = [Ts, mnr1, kr1, knr1, g];
Pnr2 = [Ts, mnr2, kr2, knr2, g];
Pmov = [l1, l2];
    
for i = 1:length(t)
    [vr1(i), xr1(i), vr2(i), xr2(i)] = TranslateMovement(Pmov, vr(i), xr(i), w(i), fi(i));
    Ft1(i) = ConventionalDamper(C1, vr1(i), vnr1(i));
    Ft2(i) = ConventionalDamper(C2, vr2(i), vnr2(i));
    if (i < length(t))
        [vnr1(i+1), xnr1(i+1)] = nr_model(Pnr1, vnr1(i), xnr1(i), xr1(i), x01(i), Ft1(i));
        [vnr2(i+1), xnr2(i+1)] = nr_model(Pnr2, vnr2(i), xnr2(i), xr2(i), x02(i), Ft2(i));
        [vr(i+1), xr(i+1), w(i+1), fi(i+1)] = half_model(Pr, vr(i), xr(i), w(i), fi(i), xnr1(i), Ft1(i), xnr2(i), Ft2(i), xr1(i), xr2(i));
    end
end

figure;
subplot(3, 1, 1);
plot(t, x01);
subplot(3, 1, 2);
plot(t, xnr1);
subplot(3, 1, 3);
plot(t, xr1);

figure;
subplot(3, 1, 1);
plot(t, x02);
subplot(3, 1, 2);
plot(t, xnr2);
subplot(3, 1, 3);
plot(t, xr2);

figure;
subplot(3, 1, 1);
plot(t, xr);
subplot(3, 1, 2);
plot(t, fi);