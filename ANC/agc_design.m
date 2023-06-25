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
Amp = 0.8 .* offset_voltage .* (1 + sin(2 .* pi .* 1 .* time)) ./ 4;
signal = Amp .* sin(2 .* pi .* f .* time);

agc_horizon = 100;


gain = gain_table(1);

k = 1;

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
        agc_gain(k) = gain;
        switch(gain)
            case 2
                if (adc_pp(k) < 2048)
                    agc_gain(k) = 4;
                end
            case 4
                if (adc_pp(k) > 3840)
                    agc_gain(k) = 2;
                end
                if (adc_pp(k) < 1638)
                    agc_gain(k) = 10;
                end
            case 10
                if (adc_pp(k) > 3840)
                    agc_gain(k) = 4;
                end
                if (adc_pp(k) < 2048)
                    agc_gain(k) = 20;
                end
            case 20
                if (adc_pp(k) > 3840)
                    agc_gain(k) = 10;
                end
            otherwise
        end
        gain = agc_gain(k);
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
stairs(time_agc, max_adc);
hold on;
stairs(time_agc, min_adc);
stairs(time_agc, adc_pp);
stairs(time_agc, agc_gain * 4096 / 20);