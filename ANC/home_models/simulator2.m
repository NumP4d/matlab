close all;
clear;
clc;

% Load FIR models
load('noise_ref_B.mat');
load('noise_err_B.mat');
load('cancel_ref_B.mat');
load('cancel_err_B.mat');

B_iir = [0.9883, -2.9635, 2.9635, -0.9883];

A_iir = [1.0000, -2.9751, 2.9518, -0.9767];

nIIR  = length(B_iir);

B_FIR = [-0.0003, -0.0010, -0.0020, -0.0037, ...
         -0.0056, -0.0070, -0.0067, -0.0033, ...
          0.0045,  0.0174,  0.0351,  0.0563, ...
          0.0787,  0.0994,  0.1152,  0.1239, ...
          0.1239,  0.1152,  0.0994,  0.0787, ...
          0.0563,  0.0351,  0.0174,  0.0045, ...
         -0.0033, -0.0067  -0.0070, -0.0056, ...
         -0.0037, -0.0020, -0.0010, -0.0003];
    
nFIR = length(B_FIR);

% Simulation parameters
N = 2000 * 60;
n_decimate = 4;
Fs = 8000;
t = 0:1/Fs:1/Fs*(N*n_decimate - 1);
t = t';

t_decim = t(n_decimate:n_decimate:end);

nB = max([length(noise_ref_B), length(noise_err_B), ...
          length(cancel_ref_B), length(cancel_err_B)]);

% LMS algorithm parameters
sn_nB = 128;
mu = 0.01;
sn_B = [0, zeros(1, sn_nB - 1)];

% Init vectors with horizons
H_noise  = zeros(nB, 1);
H_cancel = zeros(nB, 1);

H_iir_ref_x = zeros(nIIR, 1);
H_iir_ref_y = zeros(nIIR - 1, 1);

H_iir_err_x = zeros(nIIR, 1);
H_iir_err_y = zeros(nIIR - 1, 1);

H_ref_decim = zeros(nFIR, 1);
H_err_decim = zeros(nFIR, 1);

H_out = zeros(sn_nB, 1);

H_interp = zeros(nFIR, 1);

% Init vectors with data
noise   = zeros(n_decimate, 1);
cancel  = zeros(n_decimate, 1);
ref_mic = zeros(n_decimate, 1);
err_mic = zeros(n_decimate, 1);

ref_mic_iir = zeros(n_decimate, 1);
err_mic_iir = zeros(n_decimate, 1);

% Observer variables
o_noise   = zeros(N * n_decimate, 1);
o_cancel  = zeros(N * n_decimate, 1);
o_ref_mic = zeros(N * n_decimate, 1);
o_err_mic = zeros(N * n_decimate, 1);
o_err_mic_decim = zeros(N, 1);
o_err_mic_decim_lms = zeros(N, 1);
o_error = zeros(N, 1);

o_sn_B    = zeros(N, sn_nB);

energy = 0;

out_dly = 0;

for i = 1:N
   %% Simulation part of DAC and ADC
   for k = 1:n_decimate
      H_noise  = [noise(k);  H_noise(1:end-1)];
      H_cancel = [cancel(k); H_cancel(1:end-1)];
      
      ref_mic(k) = noise_ref_B * H_noise + cancel_ref_B * H_cancel;
      err_mic(k) = noise_err_B * H_noise + cancel_err_B * H_cancel;
   end
   
   % Observe variables
   o_idx = (1 + (i - 1) * n_decimate):(i * n_decimate);
   o_noise(o_idx)   = noise;
   o_cancel(o_idx)  = cancel;
   o_ref_mic(o_idx) = ref_mic;
   o_err_mic(o_idx) = err_mic;
   
   %% Microcontroller processing part
   
   % Perform IIR on input signals
   for k = 1:n_decimate
       % Reference microphone
       H_iir_ref_x = [ref_mic(k); H_iir_ref_x(1:end-1)];
       ref_mic_iir(k) = B_iir * H_iir_ref_x - A_iir(2:end) * H_iir_ref_y;
       H_iir_ref_y = [ref_mic_iir(k); H_iir_ref_y(1:end-1)];
       
       % Error microphone
       H_iir_err_x = [err_mic(k); H_iir_err_x(1:end-1)];
       err_mic_iir(k) = B_iir * H_iir_err_x - A_iir(2:end) * H_iir_err_y;
       H_iir_err_y = [err_mic_iir(k); H_iir_err_y(1:end-1)];
   end
   
   % Perform FIR with decimation
   % Reference microphone
   H_ref_decim = [ref_mic_iir; H_ref_decim(1:end - n_decimate)];
   ref_mic_decim = B_FIR * H_ref_decim;
   
   % Error microphone
   H_err_decim = [err_mic_iir; H_err_decim(1:end - n_decimate)];
   err_mic_decim = B_FIR * H_err_decim;
   
   %%% Proper algorithm
   
   % NLMS algorithm
   %if (i >= 10)
      energy = energy + H_out(1) * H_out(1);
      error = err_mic_decim - sn_B * H_out;
      o_err_mic_decim(i) = err_mic_decim;
      o_err_mic_decim_filt(i) = sn_B * H_out;
      o_error(i) = error;
      %sn_B = sn_B + mu * error * H_out' / (H_out' * H_out + 0.000001);
      sn_B = sn_B + mu * error * H_out' / (energy + 0.000001);
      energy = energy - H_out(end) * H_out(end);
      energy = 0.999999 * energy;
   %end

   % Random noise perturbation
   out = out_dly;
   out_dly = randn(1, 1) / 4;
   H_out = [out_dly; H_out(1:end-1)];

   % Interpolate and set new output signal
   for k = 1:n_decimate
       if (k == n_decimate)
           outVal = out;
       else
           outVal = 0;
       end
       
       H_interp = [outVal; H_interp(1:end-1)];
       
       cancel(k) = n_decimate * B_FIR * H_interp;
   end
   
   % Observe variables
   o_sn_B(i, :) = sn_B;
   
end

% Save latest Sn model path
save('sn_B.mat', 'sn_B');

figure;
subplot(2, 1, 1);
plot(t, o_err_mic, 'b');
grid on;
ylabel('mikrofon błędu');
%subplot(2, 2, 2);
%plot(t, o_err_mic, 'b');
%grid on;
subplot(2, 1, 2);
%plot(t, o_noise, 'b');
%grid on;
%subplot(2, 2, 4);
plot(t, o_cancel, 'b');
grid on;
xlabel('czas, s');
ylabel('sterowanie');

figure;
plot(t_decim, o_sn_B);
grid on;

load('sn_C.mat');

[h_n, wn] = freqz(sn_B, 1, Fs/n_decimate);
figure;
plot(real(h_n), imag(h_n), 'b');
grid on;

[h_n2, wn] = freqz(sn_C*2, 1, Fs/n_decimate);
hold on;
plot(real(h_n2), imag(h_n2), 'r');
grid on;

figure;
subplot(2, 1, 1);
plot(wn, abs(h_n), 'b');
grid on;
hold on;
plot(wn, abs(h_n2), 'r');
subplot(2, 1, 2);
plot(wn, angle(h_n), 'b');
grid on;
hold on;
plot(wn, angle(h_n2), 'r');

figure;
subplot(2, 1, 1);
stairs(o_err_mic_decim, 'r');
hold on;
grid on;
stairs(o_err_mic_decim_filt, 'k--');
subplot(2, 1, 2);
stairs(o_error, 'r');