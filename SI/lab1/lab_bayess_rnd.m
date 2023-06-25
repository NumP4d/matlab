clear;
close all;
clc;

N = 100;

rng('default')  % For reproducibility

A1(:, 1) = 7.*rand(N, 1) + 0.5;
A1(:, 2) = 3.*rand(N, 1).*rand(N, 1) + 0.5;
A1(:, 3) = 5.5.*rand(N, 1).*rand(N, 1);
A1(:, 4) = A1(:, 1) .* 0.25 + A1(:, 3) .* 0.6 + 0.1 .* randn(N, 1);
A1(:, 5) = 12.*rand(N, 1).*rand(N, 1) + 2;
A1(:, 6) = A1(:, 2) .* randn(N, 1);
 
mu2 = [2 2 2 2 2 2];
Sigma2 = eye(6);
A2 = mvnrnd(mu2, Sigma2, N);

A = [ A1; A2 ];
d = [ -ones(100, 1); ones(100, 1) ];

test_index = 67:100;
learn_index = 1:66;
k = 6;

A_learn = [A1(learn_index, :); A2(learn_index, :)];
d_learn = [d(learn_index); d(N + learn_index)];
A_test = [A1(test_index, :); A2(test_index, :)];
d_check = [d(test_index); d(N + test_index)];

% Naive Bayess classification method
cl_naive = NaiveBayess;
cl_naive = cl_naive.Train(A_learn, d_learn);
[d_naive, perror_naive] = cl_naive.Classify(A_test);
acc_naive = accuracy(d_naive, d_check)

figure;
scatter(A_test(d_check == -1, 1), A_test(d_check == -1, 2), 'r.');
hold on;
grid on;
scatter(A_test(d_check == 1, 1), A_test(d_check == 1, 2), 'b.');
scatter(A_test(d_naive == -1, 1), A_test(d_naive == -1, 2), 'ro');
scatter(A_test(d_naive == 1, 1), A_test(d_naive == 1, 2), 'bo');
xlabel('x1');
ylabel('x2');
title('Naiwny klasyfikator Bayessowski');

bw = logspace(-2, 1);
acc = zeros(size(bw));
for i = 1:length(bw)
    cl_parzen = BayessParzen;
    cl_parzen = cl_parzen.Train(A_learn, d_learn, bw(i));
    [d_parzen, perror_parzen] = cl_parzen.Classify(A_test);
    acc(i) = accuracy(d_parzen, d_check);
end
figure;
plot(bw, acc, 'b.');
hold on;
grid on;
plot(bw, acc, 'b');
set(gca, 'XScale', 'log')
xlabel('Bandwidth');
ylabel('Accuracy');
title('Dokładność klasyfikacji w funkcji szerokości okna');

[acc_max, imax] = max(acc);

cl_parzen = BayessParzen;
cl_parzen = cl_parzen.Train(A_learn, d_learn, bw(imax));
[d_parzen, perror_parzen] = cl_parzen.Classify(A_test);
acc_parzen = accuracy(d_parzen, d_check)

figure;
scatter(A_test(d_check == -1, 1), A_test(d_check == -1, 2), 'r.');
hold on;
grid on;
scatter(A_test(d_check == 1, 1), A_test(d_check == 1, 2), 'b.');
scatter(A_test(d_parzen == -1, 1), A_test(d_parzen == -1, 2), 'ro');
scatter(A_test(d_parzen == 1, 1), A_test(d_parzen == 1, 2), 'bo');
xlabel('x1');
ylabel('x2');
title('Metoda z wykorzystaniem okien Parzena');