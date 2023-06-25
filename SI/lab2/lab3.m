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
N = 10;
threshold = 20;
num_trees = 20;

%[X_selected, i_features, variance] = selection_var(X_learn, N, 'n');
[X_selected, i_features, variance] = selection_var(X_learn, threshold, 'threshold');
%[X_selected, i_features, dist] = selection_mean_dist(X_learn, D_learn, N, 'n');
%[X_selected, i_features, dist] = selection_mean_dist(X_learn, D_learn, threshold, 'threshold');

disp(['Wybrane cechy:', num2str(i_features)]);
% figure;
% scatter3(X_selected(D_learn == 0, 1), X_selected(D_learn == 0, 2), X_selected(D_learn == 0, 3), 'b.');
% hold on;
% grid on;
% scatter3(X_selected(D_learn == 1, 1), X_selected(D_learn == 1, 2), X_selected(D_learn == 1, 3), 'r.');
% xlabel('x1');
% ylabel('x2');
% zlabel('x3');

[D_classifier, accuracy] = classifier(X_selected, D_learn, X_test(:, i_features), D_test, num_trees);
disp(['Dokladnosc:', num2str(accuracy)]);