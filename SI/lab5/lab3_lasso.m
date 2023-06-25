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
N = [5:15];
num_trees = 20;
accuracy = zeros(1, length(N)*2);
for i = 1:length(N)
    [B,FitInfo] = lasso(X_learn, D_learn, 'Alpha', 0.75, 'CV', 10);
    [B_sorted, i_sorted] = sort(B(:, FitInfo.IndexMinMSE), 'descend');
    i_features = i_sorted(1:N(i))';

    disp(['Wybrane cechy:', num2str(i_features)]);
    [D_classifier, accuracy(i)] = classifier(X_learn(:, i_features), D_learn, X_test(:, i_features), D_test, num_trees);
    disp(['Dokladnosc:', num2str(accuracy(i))]);
end
N1 = 30;
[X_selected, i_features, variance] = selection_var(X_learn, N1, 'n');

for i = 1:length(N)
    [B,FitInfo] = lasso(X_selected, D_learn, 'Alpha', 0.75, 'CV', 10);
    [B_sorted, i_sorted] = sort(B(:, FitInfo.IndexMinMSE), 'descend');
    i_features_ = i_features(i_sorted(1:N(i)));

    disp(['Wybrane cechy:', num2str(i_features_)]);
    [D_classifier, accuracy(i+length(N))] = classifier(X_learn(:, i_features_), D_learn, X_test(:, i_features_), D_test, num_trees);
    disp(['Dokladnosc:', num2str(accuracy(i))]);
end

figure;
scatter(N, accuracy(1:length(N)), 'r.');
hold on;
grid on;
scatter(N, accuracy(length(N)+1:end), 'b.');
plot(N, accuracy(1:length(N)), 'r');
plot(N, accuracy(length(N)+1:end), 'b');
xlabel('N');
ylabel('accuracy');
legend('lasso', 'filter + lasso');