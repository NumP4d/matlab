clear;
close all;
clc;

% Data preparation

rng('default');

csv0 = csvread('0.csv');
csv2 = csvread('2.csv');

csv0(:, 65) = 0;
csv2(:, 65) = 1;

A = [csv0; csv2];
X = A(:, 1:(end-1));
D = [csv0(:, 65); csv2(:, 65)];

k = size(X, 1);
itest = (rand(k, 1) < 1/3);
ilearn = ~itest;

X_learn = X(ilearn, :);
D_learn = D(ilearn, :);
X_test = X(itest, :);
D_test = D(itest, :);

% Feature selection
N1 = 30;
N2 = 5;
num_trees = 20;

[X_selected, i_features1, dist] = selection_mean_dist(X_learn, D_learn, N1, 'n');
[X_selected, i_features, variance] = selection_var(X_selected, N2, 'n');

disp(['Wybrane cechy:', num2str(i_features)]);
[D_classifier, accuracy] = classifier(X_selected, D_learn, X_test(:, i_features), D_test, num_trees);
disp(['Dokladnosc:', num2str(accuracy)]);
unique(D_classifier)
% wrapper selection
N1 = 15;
N2 = 10;

% Data preparation for wrapper
k = size(X_learn, 1);
itest = (rand(k, 1) < 1/3);
ilearn = ~itest;

X_learn_wr = X_learn(ilearn, :);
D_learn_wr = D_learn(ilearn, :);
X_test_wr = X_learn(itest, :);
D_test_wr = D_learn(itest, :);

[X_selected, i_features, ~] = wrapper(X_learn, D_learn, X_learn_wr, D_learn_wr, X_test_wr, D_test_wr, N1, N2, num_trees, 'mean_dist');

disp(['Wybrane cechy:', num2str(i_features)]);
[D_classifier, accuracy] = classifier(X_learn(:, i_features), D_learn, X_test(:, i_features), D_test, num_trees);
disp(['Dokladnosc:', num2str(accuracy)]);