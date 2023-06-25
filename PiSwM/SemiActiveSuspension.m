clear;
close all;
clc;

% Car parameters
mr_half = 580;  % kg
J_half  = 1039; % kgm^2
l1      = 0.99; % m
l2      = 1.81; % m
mnr_1   = 60;   % kg
kr_1    = 15;   % kN/m
knr_1   = 200;  % kN/m
mnr_2   = 60;   % kg
kr_2    = 14;   % kN/m
knr_2   = 200;  % kN/m

% Simulation parameters
t_sim = 200;
Ts = 0.001;

t = 0:Ts:t_sim;

% Road disturbance
%w0      = 2 * pi * 1;
%x0_1    = 0.02 * sin(w0 * t);
%x0_2    = 0.02 * sin(w0 * t);
x0_1    = zeros(size(t));
x0_2    = zeros(size(t));
v_car   = 0.5; % km/h
L_bumper= 0.3;
H_bumper= 0.1;
t_bumper= 0:Ts:(L_bumper / v_car);
f_bumper= 2*pi*(1 ./ (2 * L_bumper / v_car));
bumper  = H_bumper * sin( f_bumper * t_bumper);
%x0_1(1:length(bumper)) = bumper;
t_2     = (l1 + l2) / v_car / Ts;
%x0_2(t_2:(t_2 - 1 + length(bumper))) = bumper;

x0_1 = ones(size(t));
x0_2 = ones(size(t));
x0_1(1) = 0;
x0_2(1) = 0;

% Magnetorheological dampers
Ft_1    = 0;
Ft_2    = 0;

% Car suspension process variables
xr_half = 0;
fi      = 0;
xnr_1   = 0;
xnr_2   = 0;

vr_half = 0;
wi      = 0;
vnr_1   = 0;
vnr_2   = 0;

for i = 1:length(t)
    [xr_half, fi, xnr_1, xnr_2, vr_half, wi, vnr_1, vnr_2] ...
        = CarSuspensionModel(x0_1, x0_2, Ft_1, Ft_2, xr_half, fi, xnr_1, xnr_2, vr_half, wi, vnr_1, vnr_2, Ts);
    [Ft_1] = ConventionalDamper(vr_half, vnr_1, Ft_1);
    [Ft_2] = ConventionalDamper(vr_half, vnr_2, Ft_2);
end

figure;
subplot(2, 1, 1);
plot(t, x0_1);
subplot(2, 1, 2);
plot(t, x0_2);

figure;
subplot(2, 2, 1);
plot(t, xr_half(2:end));
subplot(2, 2, 2);
plot(t, fi(2:end));
subplot(2, 2, 3);
plot(t, xnr_1(2:end));
subplot(2, 2, 4);
plot(t, xnr_2(2:end));