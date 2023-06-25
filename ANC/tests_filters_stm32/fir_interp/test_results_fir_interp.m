clear;
close all;
clc;

fid1 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_fir_circular_interp/input_vector.csv', 'r');
fid2 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_fir_circular_interp/output_vector.csv', 'r');
fid3 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_fir_circular_interp/expect_vector.csv', 'r');

in      = fscanf(fid1, '%f\n');
out     = fscanf(fid2, '%f\n');
expect  = fscanf(fid3, '%f\n');

error = out - expect;

fclose(fid1);
fclose(fid2);
fclose(fid3);

Fs = 2000;
n = 1024;

f1 = 0:Fs/(2*n):Fs/2;

Fs = 8000;
n = 1024;

f = 0:Fs/(2*n):Fs/2;

welch_in  = pwelch(in, n*2);
welch_out = pwelch(out, n*2);
welch_expect = pwelch(expect, n*2);

figure;
semilogx(f1, welch_in, 'b');
hold on;
semilogx(f, welch_out, 'r');
semilogx(f, welch_expect, 'k--');

figure;
stairs(out, 'r');
hold on;
stairs(expect, 'k--');
grid on;
%stairs(error, 'b');
xlim([0, 100]);
legend('algorytm w języku C', 'algorytm w Matlab');
xlabel('krok');
ylabel('wartość');