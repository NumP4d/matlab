clear;
close all;
clc;

N = 100;

rng('default')  % For reproducibility

mu1 = [0 0];
Sigma1 = [2 -1; -1 2]; %R1 = chol(Sigma1);
%A1 = repmat(mu1,N,1) + randn(N,2)*R1;
A1 = mvnrnd(mu1, Sigma1, N);
 
mu2 = [2 2];
Sigma2 = [1 0; 0 1]; %R2 = chol(Sigma2);
%A2 = repmat(mu2,N,1) + randn(N,2)*R2;
A2 = mvnrnd(mu2, Sigma2, N);

A = [ A1; A2 ];
d = [ -ones(100, 1); ones(100, 1) ];

figure;
scatter(A1(:, 1), A1(:, 2), 'r.'); 
hold on;
grid on;
scatter(A2(:, 1), A2(:, 2), 'b.');

test_index = 67:100;
learn_index = 1:66;
k = 6;

A_learn = [A1(learn_index, :); A2(learn_index, :)];
d_learn = [d(learn_index); d(N + learn_index)];
A_test = [A1(test_index, :); A2(test_index, :)];
d_check = [d(test_index); d(N + test_index)];

% [d_test, prob_test] = bayess(A_learn, d_learn, A_test, k);
% 
% figure;
% scatter(A_test(d_check == -1, 1), A_test(d_check == -1, 2), 'r.');
% hold on;
% grid on;
% scatter(A_test(d_check == 1, 1), A_test(d_check == 1, 2), 'b.');
% scatter(A_test(d_test == -1, 1), A_test(d_test == -1, 2), 'ro');
% hold on;
% grid on;
% scatter(A_test(d_test == 1, 1), A_test(d_test == 1, 2), 'bo');
% for i = 1:size(A_learn, 2)
%     dens1(:, i) = normpdf(A_learn(d_learn == -1, i));
%     dens2(:, i) = normpdf(A_learn(d_learn == 1, i));
% end
% 	
% figure;
% scatter(A_learn(d_learn == -1, 1), dens1(1));

% Learning classifier first trial:pr

mu1_est = mean(A_learn(d_learn == -1, :))
Sigma1_est = std(A_learn(d_learn == -1, :));

mu2_est = mean(A_learn(d_learn == 1, :))
Sigma2_est = std(A_learn(d_learn == 1, :));

% Naive Bayess classification method:

prob_1 = normpdf(A_test, mu1_est, Sigma1_est);
prob_2 = normpdf(A_test, mu2_est, Sigma2_est);

% Set plots
[A_test_sorted, i_sorted] = sort(A_test);
figure;
scatter(A_test(:, 1), prob_1(:, 1), 'r.');
plot(A_test_sorted(:, 1), prob_1(i_sorted(:, 1), 1), 'r--');
hold on;
grid on;
scatter(A_test(:, 1), prob_2(:, 1), 'b.');
plot(A_test_sorted(:, 1), prob_2(i_sorted(:, 1), 1), 'b--');

figure;
scatter(A_test(:, 2), prob_1(:, 2), 'r.');
plot(A_test_sorted(:, 2), prob_1(i_sorted(:, 2), 2), 'r--');
hold on;
grid on;
scatter(A_test(:, 2), prob_2(:, 2), 'b.');
plot(A_test_sorted(:, 2), prob_2(i_sorted(:, 2), 2), 'b--');

prob_1_mult = prob_1(:, 1) .* prob_1(:, 2);
prob_2_mult = prob_2(:, 1) .* prob_2(:, 2);

d_test = double(prob_2_mult > prob_1_mult);
d_test(d_test == 0) = -1;

p_test = zeros(size(d_test));
p_test(d_test == -1) = prob_1_mult(d_test == -1);
p_test(d_test == 1)  = prob_2_mult(d_test == 1);
p_test = p_test .* 100 ./ (prob_1_mult + prob_2_mult);

figure;
scatter(A_test(d_check == -1, 1), A_test(d_check == -1, 2), 'r.'); 
hold on;
grid on;
scatter(A_test(d_check == 1, 1), A_test(d_check == 1, 2), 'b.');

scatter(A_test(d_test == -1, 1), A_test(d_test == -1, 2), 'ro');
scatter(A_test(d_test == 1, 1), A_test(d_test == 1, 2), 'bo');

scatter(A_test(p_test < 60, 1), A_test(p_test < 60, 2), 'kx');

sum(d_check ~= d_test);

