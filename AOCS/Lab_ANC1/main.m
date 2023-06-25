clear;
close all;
clc;

LoadData;

TimeSim = 10;
T_on = 1;
time = 0:1/Fs:TimeSim;

N = 128;

noise = zeros(1, N);

N_mic = 5;
mics = zeros(N_mic, N);

N_act = 21;
act = zeros(N_act, N);

ref_mic = zeros(1, N);

% Initialize control algorithm

% Initialize control values at start to zeros
new_act = zeros(N_act, 1);

wn = zeros(N_act, N);
wn(:, 1) = ones(N_act, 1);

% FxLMS parameters
alpha = 1;
mu = 100;

% Estimated S paths are the same as used in simulation
S = B_act;

% Init r values vector
r = {};
for j = 1:N_mic
    for k = 1:N_act
        r{k, j} = zeros(1, N);
    end
end

% Generate noise signal
[B1, A1] = butter(7, 0.25);
[B2, A2] = butter(7, 0.15, 'High');

% Single-tone sine signal
%noise_gen = [zeros(1, N), sin(2 * pi * 200 * time)];
% Multi-tone sine signal
noise_gen = [zeros(1, N), sin(2 * pi * 200 * time) + sin(2 * pi * 125 * time) * 3 + sin(2 * pi * 78 * time)]; 
% Band-limited white noise signal
%noise_gen = filter(B2, A2, filter(B1, A1, randn(1, length(time) + N)));

run = 1;

if (run == 1)
   for i = 1:length(time)
       
       %%%%% Simulation part %%%%%
       
       % Obtain noise signal
       noise = noise_gen(1:N + i);
       
       % Store actuator (set actuator)
       act = [act, new_act];
       
       mics = [mics, zeros(N_mic, 1)];
       for j = 1:N_mic
           noise_mic = B_speaker{j} * noise((end-(N-1)):end)';
           
           act_mic = 0;
           for k = 1:N_act
               act_mic = act_mic + B_act{j, k} * act(k, (end-(N-1)):end)';
           end
           
           mics(j, end) = noise_mic + act_mic;
       end
       
       % Calculate noise source to reference microphone path
       new_ref_mic = B_ref * noise((end-(N-1)):end)';
       %new_ref_mic = noise(end);    % ideal microphone
       % Store reference microphone
       ref_mic = [ref_mic, new_ref_mic];
       
       %%%%% Control part %%%%%
       
       if (time(i) >= T_on)
           % Observe proper values:
           e = mics(:, end); % 5x1 vector

           % Calculate r and store this values
           for j = 1:N_mic
               for k = 1:N_act
                   r{k, j} = [r{k, j}, S{j, k} * ref_mic((end-(N-1)):end)'];
               end
           end

           % Adapt wn filter using FxLMS algorithm:
           for j = 1:N_act
               for k = 1:N_mic
                   wn(j, :) = alpha * wn(j, :) - mu * r{j, k}((end-(N-1)):end) * e(k);
               end
           end

           % Generate new actuator values
           new_act = wn * ref_mic((end-(N-1)):end)';
       end
   end
end

figure;
plot(time, mics(:, (N+1):end));
grid on;
legend('Front', 'Right', 'Back', 'Left', 'Top');

sound(mics(1, (N+1):end) / (max(mics(1, (N+1):end))));

% Calculate PSD for end of simulation and before enabling filter
mic_n = 1;
mic_channel = mics(mic_n, (N+1):end);
mic_off = mic_channel((time > (T_on - 0.5)) & (time <= T_on));
mic_on = mic_channel(time > (TimeSim - 0.5));
fft_off = 10*log10(pwelch(mic_off, 512));
fft_on = 10*log10(pwelch(mic_on, 512));
f_pwelch = 0:Fs/512:Fs/2;

noise_reduction = 10*log10(var(mic_on)) - 10*log10(var(mic_off));
disp(['Total noise reduction: ', num2str(noise_reduction), ' dB']);

figure;
plot(f_pwelch, fft_off, 'r');
hold on;
grid on;
plot(f_pwelch, fft_on, 'b');
xlabel('frequency, Hz');
ylabel('PSD, dB');
legend('ANC off', 'ANC on');