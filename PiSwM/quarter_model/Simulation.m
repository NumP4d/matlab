clear;
close all;
clc;

% Car parameters
mr    = 580 / 2;    % kg
mnr   = 60;         % kg
kr    = 15 * 1000;  % kN/m
knr   = 200 * 1000; % N/m
g     = 9.81;       % m/s2

% Steady-state parameters from gravitation
xnrst = (mr + mnr) * g / knr;
xrst  = mr * g / kr + xnrst;

% Damper parameter
C = 1185; % Ns/m
    
% Simulation parameters
t_sim = 40;
Ts = 0.001;

t = 0:Ts:t_sim;

% Create vectors
xr  = zeros(size(t));
vr  = zeros(size(t));
xnr = zeros(size(t));
vnr = zeros(size(t));
Ft  = zeros(size(t));

% Initial conditions
xr(1)  = xrst;
xnr(1) = xnrst;

% Create road vector
x0    = ones(size(t));
x0(1) = 0;
x0(length(t)/2:end) = 0;

% Create Vectored parameters
Pr  = [Ts, mr, kr, g];
Pnr = [Ts, mnr, kr, knr, g];

for i = 1:(length(t)-1)
    Ft(i) = ConventionalDamper(C, vr(i), vnr(i));
    [vnr(i+1), xnr(i+1)] = nr_model(Pnr, vnr(i), xnr(i), xr(i), x0(i), Ft(i));
    [vr(i+1), xr(i+1)] = quarter_model(Pr, vr(i), xr(i), xnr(i), Ft(i));
end

Ft(end) = ConventionalDamper(C, vr(end), vnr(end));

figure;
subplot(3, 1, 1);
plot(t, x0);
subplot(3, 1, 2);
plot(t, xnr);
subplot(3, 1, 3);
plot(t, xr);