clear;
close all;
clc;

fid1 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_fxlms/input_vector.csv', 'r');
fid2 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_fxlms/output_vector.csv', 'r');
fid3 = fopen('/home/klukomski/workspace/stm32/stm32-anc/tests/test_fxlms/expect_vector.csv', 'r');

in      = fscanf(fid1, '%f\n');
out     = fscanf(fid2, '%f\n');
expect  = fscanf(fid3, '%f\n');

ident_error = out(1:4:end);
ref_mic     = out(2:4:end);
err_mic     = out(3:4:end);
out_dac     = [0; out(8:4:end)];

error = err_mic - ident_error;

time_on = 2000*100;

figure;
subplot(2, 1, 1);
stairs(ref_mic, 'r');
grid on;
hold on;
line([time_on time_on], [-1 1]);;
subplot(2, 1, 2);
stairs(err_mic, 'r');
grid on;
hold on;
stairs(ident_error, 'k--');
hold on;
line([time_on time_on], [-1 1]);;
title('ref and err mic');

figure;
subplot(2, 1, 1);
stairs(out_dac, 'r');
grid on;
hold on;
line([time_on time_on], [-1 1]);;
subplot(2, 1, 2);
stairs(in(4:4:end), 'r');
grid on;
hold on;
line([time_on time_on], [-1 1]);;
title('Out dac and noise');

figure;
stairs(error, 'k--');
grid on;
hold on;
line([time_on time_on], [-1 1]);;

title('Identification error');
xlabel('step');
ylabel('value');
%legend('algorithm in C', 'algorithm in Matlab');