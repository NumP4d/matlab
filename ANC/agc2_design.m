clear;
close all;
clc;

full_voltage        = 3.3;
offset_voltage      = 1.65;
amp_offset_voltage  = -0.02;

adc_resolution  = 4096;
adc_offset      = 2048;

gain_table = [2, 4, 10, 20];

Fs = 8000;
Ts = 1/Fs;
time_end = 2;
time = 0:Ts:time_end;

f = 100;
Amp = 0.8 .* offset_voltage .* (1 + sin(2 .* pi .* 5 .* time)) ./ 4;
signal = Amp .* sin(2 .* pi .* f .* time);

agc_horizon = 4;


[Bf, Af] = butter(1, 10/(Fs/2));
R = 0.27;
alpha = 120;

gain = gain_table(1);

k = 1;

square_avg_old = 0;
square_avg_lowpass_old = 0;

for i = 1:length(time)
    amplified_signal(i) = gain * (signal(i) + amp_offset_voltage) + offset_voltage;
    adc_signal(i) = round(amplified_signal(i) ./ full_voltage .* adc_resolution);
    if (adc_signal(i) >= adc_resolution)
        adc_signal(i) = adc_resolution - 1;
    end
    if (adc_signal(i) < 0)
        adc_signal(i) = 0;
    end
    retrived_signal(i) = (adc_signal(i) ./ adc_resolution .* full_voltage - offset_voltage) ./ gain - amp_offset_voltage; 
    if (mod(i, agc_horizon) == 0)
        adc_agc_horizon = adc_signal((i-agc_horizon+1):i);
        max_adc(k) = max(adc_agc_horizon);
        min_adc(k) = min(adc_agc_horizon);
        adc_pp(k)  = max_adc(k) - min_adc(k);
        time_agc(k) = time(i);
        
        average = mean(adc_agc_horizon);
        %square_avg(k) = (average - 2048) * (average - 2048) / 2048 / 2048;
        square_avg(k) = (average/4096) * (average/4096);
        square_avg_lowpass(k) = Bf(1) * square_avg(k) + Bf(2) * square_avg_old - Af(2) * square_avg_lowpass_old;
        square_avg_lowpass_old = square_avg_lowpass(k);
        square_avg_old = square_avg(k);
        
        error(k) = log2(R) - log2(square_avg_lowpass(k));
        agc_gain(k) = gain;
        gain_tmp(k) = agc_gain(k) + alpha * error(k);
        if (gain_tmp(k) < 4)
            gain = 2;
        elseif (gain_tmp(k) < 10)
            gain = 4;
        elseif (gain_tmp(k) < 20)
            gain = 10;
        else
            gain = 20;
        end
        %gain = gain_tmp(k);
        agc_gain(k) = gain;
        
        k = k + 1;
    end
end

figure;
subplot(3, 1, 1);
plot(time, signal);
hold on;
grid on;
plot(time, retrived_signal);
subplot(3, 1, 2);
plot(time, amplified_signal);
grid on;
subplot(3, 1, 3);
grid on;
stairs(time, adc_signal);

figure;
stairs(time_agc, time_agc .* 0 + R);
hold on;
%stairs(time_agc, square_avg);
hold on;
stairs(time_agc, square_avg_lowpass);

figure;
subplot(3, 1, 1);
stairs(time_agc, error);
subplot(3, 1, 2);
stairs(time_agc, error * alpha);
subplot(3, 1, 3);
stairs(time_agc, gain_tmp);
hold on;
stairs(time_agc, agc_gain);