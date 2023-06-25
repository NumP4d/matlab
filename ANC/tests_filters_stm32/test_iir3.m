clear all;
close all;
clc;

fid1 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_vector_0.csv', 'r');
fid2 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/output_vector.csv', 'r');

in  = fscanf(fid1, '%f\n');
out = fscanf(fid2, '%f\n');

fclose(fid1);
fclose(fid2);

Fs = 2000;
n = 1024;

f = 0:Fs/(2*n):Fs/2;

welch_in  = pwelch(in, n*2);
welch_out = pwelch(out, n*2);

figure;
semilogx(f, welch_in, 'r');
hold on;
semilogx(f, welch_out, 'b');


B = [10846, -32271, 32271, -10846];
A = [-32768, 31762, -10340];

in_q15  = double(int16(fix(in * 32768)));
out_q15 = double(int16(fix(out * 32768)));

y_q15 = zeros(size(in_q15));

H_x = zeros(4, 1);
H_y = zeros(3, 1);

for i = 1:length(in_q15)
    H_x = [in_q15(i); H_x(1:end-1)];
    %y_q15(i) = B * H_x - A * H_y; 
    sum = int32(0);
    for k = 1:4
        sum = int32(sum + B(k) * H_x(k));
        if (sum == (2^31-1) || sum == -2^31)
            print("Overflow!");
        end
    end
    for k = 1:3
        sum = int32(sum - A(k) * H_y(k));
        if (sum == (2^31-1) || sum == -2^31)
            print("Overflow!");
        end
    end
    y_q15(i) = int16(fix(sum / 32768));
    H_y = [y_q15(i); H_y(1:end-1)];
end

welch_in  = pwelch(in_q15, n*2);
welch_y   = pwelch(y_q15, n*2);
welch_out = pwelch(out_q15, n*2);

figure;
semilogx(f, welch_in, 'r');
hold on;
semilogx(f, welch_out, 'b--');
%semilogx(f, welch_y, 'k--');

figure;
stairs(out_q15 / 32768, 'b');
hold on;
grid on;
stairs(y_q15 / 32768, 'k--');
stairs(in_q15 / 32768, 'r');
xlim([0; 100]);

figure;

mean_in = zeros(1, 2000);
mean_out = zeros(1, 2000);

for i = 0:9
    for j = 1:2000
        mean_in(j)  = mean_in(j)  +  in(i * 2000 + j);
        mean_out(j) = mean_out(j) +  out(i * 2000 + j);
    end
end

mean_in = mean_in - mean(mean_in);
mean_out = mean_out - mean(mean_out);

f = 1:1:Fs/2;
fft_in = fft(mean_in);
fft_out = fft(mean_out);

fft_in = fft_in(1:end/2);
fft_out = fft_out(1:end/2);

figure;
semilogx(f, 10*log10(abs(fft_out ./ fft_in)), 'r');
hold on;
[h, w] = freqz(B, [1, A], 1000);
semilogx(f, 10*log10(abs(h)));