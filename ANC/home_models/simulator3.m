close all;
clear;
clc;

% Load FIR models
load('noise_ref_B.mat');
load('noise_err_B.mat');
load('cancel_ref_B.mat');
load('cancel_err_B.mat');

load('sn_B.mat');

sn_nB = length(sn_B);

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
N = 50000;
anc_on = 0;
n_decimate = 4;
Fs = 8000;
t = 0:1/Fs:1/Fs*(N*n_decimate - 1);
t = t';

t_decim = t(n_decimate:n_decimate:end);

nB = max([length(noise_ref_B), length(noise_err_B), ...
          length(cancel_ref_B), length(cancel_err_B)]);

% LMS algorithm parameters
wn_nB = 128;
alpha = 1;
mu = 0.01;
wn_B = [0, zeros(1, wn_nB - 1)];
%wn_B(1:2:end) = 0.25;
%wn_B(2:2:end) = -0.25;

%wn_B(1:end) = 0.25;
%wn_B = randn(1, wn_nB) / 3;

% Noise parameters
f_noise = 150;

% Init vectors with horizons
H_noise  = zeros(nB, 1);
H_cancel = zeros(nB, 1);

H_iir_ref_x = zeros(nIIR, 1);
H_iir_ref_y = zeros(nIIR - 1, 1);

H_iir_err_x = zeros(nIIR, 1);
H_iir_err_y = zeros(nIIR - 1, 1);

H_ref_decim = zeros(nFIR, 1);
H_err_decim = zeros(nFIR, 1);

H_sn_ref = zeros(sn_nB, 1);

H_fxref  = zeros(wn_nB, 1);

H_wn_ref = zeros(wn_nB, 1);

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

o_wn_B    = zeros(N, wn_nB);

energy = 0;

out_dly = 0;

for i = 1:N
    noise_idx = (1 + (i - 1) * n_decimate):(i * n_decimate);
    noise = 0.5 * sin(2 * pi * f_noise * t(noise_idx));
    if (i < 2500)
        noise = [0, 0, 0, 0];
    end
    
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
   
   % Filter ref microphone with Sn path
   if (i > anc_on)
   H_sn_ref = [ref_mic_decim; H_sn_ref(1:end-1)];
   sn_ref   = sn_B * H_sn_ref;
   
   H_fxref = [sn_ref; H_fxref(1:end-1)];
   
   % Calculate output by filtering ref signal with Wn filter
   out = out_dly;
   H_wn_ref = [ref_mic_decim; H_wn_ref(1:end-1)];
   out_dly = wn_B * H_wn_ref;
   
   energy = energy + H_fxref(1) * H_fxref(1);
   end
   % LMS algorithm
   if (i > anc_on)
   %if (i >= wn_nB)
       %wn_B = alpha * wn_B - mu * err_mic_decim * H_fxref' / (H_fxref' * H_fxref + 0.000001);
       wn_B = alpha * wn_B - mu * err_mic_decim * H_fxref' / (energy + 0.000001);
       for k = 1:length(wn_B)
           if (wn_B(k) > 10)
               wn_B(k) = 10;
           end
           if (wn_B(k) < -10)
               wn_B(k) = -10;
           end
            
       end 
   %end
   end
   if (i > anc_on)
   energy = energy - H_fxref(end) * H_fxref(end);
   % Energy leak
   energy = energy * 0.999999;
   
   else
       out = 0;
   end
   % Saturate output
   if (out > 1)
       out = 1;
   end
   if (out < -1)
       out = -1;
   end
   
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
   o_wn_B(i, :) = wn_B;
   
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
plot(t_decim, o_wn_B(:, 2:end), 'k');
%grid on;
%xlim([0, 0.8]);