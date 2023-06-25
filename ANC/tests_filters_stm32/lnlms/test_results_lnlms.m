clear;
close all;
clc;

fid1 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_lnlms/input_vector.csv', 'r');
fid2 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_lnlms/output_vector.csv', 'r');
fid3 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_lnlms/expect_vector.csv', 'r');

fid1 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_fir_circular/input_vector.csv', 'r');
fid2 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_fir_circular/output_vector.csv', 'r');
fid3 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_fir_circular/expect_vector.csv', 'r');

%fid1 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_iir3_circular/input_vector.csv', 'r');
%fid2 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_iir3_circular/output_vector.csv', 'r');
%fid3 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_iir3_circular/expect_vector.csv', 'r');

in      = fscanf(fid1, '%f\n');
out     = fscanf(fid2, '%f\n');
expect  = fscanf(fid3, '%f\n');


figure;
stairs(out, 'r');
grid on;
hold on;
stairs(expect, 'k--');
xlim([0, 200]);

legend('algorytm w języku C', 'algorytm w Matlab');
xlabel('krok');
ylabel('wartość');