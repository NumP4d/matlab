close all;
clear;
clc;

% Load FIR models
load('noise_ref_B.mat');
load('noise_err_B.mat');
load('cancel_ref_B.mat');
load('cancel_err_B.mat');

% Simulation iteration loops
N = 11000;

offline_identification_N = 10000;

% Decimation ratio
n_decimate = 4;
Fs = 8000;
t = 0:1/Fs:1/Fs*(N*n_decimate - 1);
t = t';

nB = max([length(noise_ref_B), length(noise_err_B), ...
          length(cancel_ref_B), length(cancel_err_B)]);

% Init vectors
noise   = zeros(nB, 1);
cancel  = zeros(nB, 1);

ref_decim_data = zeros(nB, 1);
err_decim_data = zeros(nB, 1);

ref_mic = zeros(nB, 1);
err_mic = zeros(nB, 1);
ref_mic_decimated = zeros(nB, 1);
err_mic_decimated = zeros(nB, 1);
out_interpolated  = zeros(nB, 1);
control_value     = zeros(nB, 1);

f = 200;
noise_off  = [noise; zeros(length(t), 1)];
noise_gen  = [noise; 1/10 * sin(2*pi*f*t)];

sn_nB = 2048;

mi_offline = 1;
sn_B = [1, zeros(1, sn_nB - 1)];

alpha = 1;
mi_fxlms = 0.001;
wn_nB = 2048;
wn_B = [1, zeros(1, wn_nB - 1)];

filtered_ref_mic = zeros(wn_nB, 1);

new_cancel = zeros(n_decimate, 1);

sum_sn_B = [];

error = [];

for i = 1:N
   %% Simulation part of DAC and ADC
   cancel = [cancel; new_cancel];
   
   if (i <= offline_identification_N)
       noise = noise_off;
   else
       %noise = noise_gen;
       noise = [noise; randn(1, 1)];
   end
   
   [ref_mic] = simulate_microphone(ref_mic, noise(1:(nB + i*n_decimate)), cancel(1:(nB + i*n_decimate)), noise_ref_B, cancel_ref_B, n_decimate); 
   [err_mic] = simulate_microphone(err_mic, noise(1:(nB + i*n_decimate)), cancel(1:(nB + i*n_decimate)), noise_err_B, cancel_err_B, n_decimate);
   
   %% Microcontroller processing part
   
   % Decimate input signals
   [ref_mic_decimated, ref_decim_data] = decimate(ref_mic_decimated, ref_decim_data, ref_mic, n_decimate);
   [err_mic_decimated, err_decim_data] = decimate(err_mic_decimated, err_decim_data, err_mic, n_decimate);
   
   sum_sn_B = [sum_sn_B; sum(sn_B)];
   
   if (i <= offline_identification_N)
       control_value_horizon = flip(control_value((end - sn_nB + 1):end));
       % NLMS for identification S path
       error = [error; err_mic_decimated(end) - sn_B * control_value_horizon];
       
       if (i >= 10)
            sn_B = sn_B + mi_offline * error(end) * control_value_horizon' ...
                 / (control_value_horizon' * control_value_horizon);
       end
       
       control_value_new = randn(1, 1);
   else
       % FxLMS for noise cancelling
       ref_mic_horizon = flip(ref_mic_decimated((end - sn_nB + 1):end));
       
       filtered_ref_mic_new = sn_B * ref_mic_horizon;
       
       filtered_ref_mic = [filtered_ref_mic; filtered_ref_mic_new];
       
       filtered_ref_mic_horizon = flip(filtered_ref_mic((end - wn_nB + 1):end));
       
       %if (i > offline_identification_N + 10)
            wn_B = alpha * wn_B - mi_fxlms * err_mic_decimated(end) * filtered_ref_mic_horizon';% ...
                 %/ (filtered_ref_mic_horizon' * filtered_ref_mic_horizon);
       %end
       
       % Generate new control value
       %control_value_new = wn_B * ref_mic_horizon;
       control_value_new = 0;
       
   end
   
   control_value = [control_value; control_value_new];
   
   % Interpolate output signal
   [out_interpolated] = interpolate(out_interpolated, control_value, n_decimate);
   
   % Set new DAC buffer
   %new_cancel = zeros(n_decimate, 1);
   new_cancel = out_interpolated((end - n_decimate + 1):end);
end

figure;
subplot(2, 2, 1);
plot(t, ref_mic(nB + 1:end), 'b');
grid on;
subplot(2, 2, 2);
plot(t, err_mic(nB + 1:end), 'b');
grid on;
subplot(2, 2, 3);
plot(t, noise(nB + 1:end), 'b');
grid on;
subplot(2, 2, 4);
plot(t, cancel(nB + 1:end), 'b');
grid on;

figure;
subplot(2, 1, 1);
plot(t(4:4:end), sum_sn_B, 'b');
grid on;
subplot(2, 1, 2);
plot(error, 'b');
grid on;