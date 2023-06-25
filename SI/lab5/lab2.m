clear all;
close all;
clc;

rng('default');

csv0 = csvread('0.csv');
csv2 = csvread('2.csv');

csv0(:, 65) = 0;
csv2(:, 65) = 1;

N = 3;
minvar = 25;
mindiff = 6;

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

var = std(X_learn);
[var_sorted, i_sorted] = sort(var, 'descend');
i_features = i_sorted(1:N);
disp(['Cechy dla max var:', num2str(i_features)]);

means0 = mean(X_learn(D_test == 0, :));
means1 = mean(X_learn(D_test == 1, :));

diff = abs(means1 - means0);

[diff_sorted, i_sorted] = sort(diff, 'descend');

%i_features = i_sorted(1:N);
X_selected = X_learn(:, i_features);
%X_selected = X_learn(:, diff>=mindiff);
disp(['Cechy dla max diff:', num2str(i_features)]);
figure;
scatter3(X_selected(D_test == 0, 1), X_selected(D_test == 0, 2), X_selected(D_test == 0, 3), 'b.');
hold on;
grid on;
scatter3(X_selected(D_test == 1, 1), X_selected(D_test == 1, 2), X_selected(D_test == 1, 3), 'r.');

% Train classifier
num_trees = 10;
random_forest_model = TreeBagger(num_trees, X_selected, D_learn, 'OOBPrediction','On',...
    'Method','classification');

%d_check = random_forest_model.predict(X_test(:, diff>=mindiff));
d_check = random_forest_model.predict(X_test(:, i_features));

d_check = str2num(char(d_check));

wskaznik = sum(d_check == D_test) ./ length(D_test)
