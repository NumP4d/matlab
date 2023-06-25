clear;
close all;
clc;

% Data preparation

%rng('default');

% X = csvread('Patterns_for_section_10.csv')';
% D = csvread('ClassLabels.csv')';

csv0 = csvread('data.txt');

X = csv0(3:end, :)';
D = csv0(1, :)';

% Dekompozycja
% Dn = [D, D, D];
% Dn(D == 3, 1) = 2; % 1 vs rest
% Dn(D == 1, 2) = 3; % 2 vs rest
% Dn(D == 1, 3) = 2; % 3 vs rest

Dn{1} = D(D ~= 3);   % 1, 2
Dn{2} = D(D ~= 2);   % 1, 3
Dn{3} = D(D ~= 1);   % 2, 3

N_monte_carlo = 50;

for i = 1:3
    accuracy = zeros(1, N_monte_carlo);
    for j = 1:N_monte_carlo
        
        X_ = X(D ~= (4 - i), :);
    
        % Feature selection
        N = 50;
        threshold = 20;
        num_trees = 5;
        
        k = size(X_, 1);
        itest = (rand(k, 1) < 0.4);
        ilearn = ~itest;
        
        Dx = Dn{i};
        X_learn = X_(ilearn, :);
        D_learn = Dx(ilearn);
        X_test = X_(itest, :);
        D_test = Dx(itest);
        
        [X_selected, i_features, variance] = selection_var(X_learn, N, 'n');
        
        %[X_selected, i_features, variance] = selection_var(X_learn, threshold, 'threshold');
        %[X_selected, i_features, dist] = selection_mean_dist(X_learn, D_learn, N, 'n');
        %[X_selected, i_features, dist] = selection_mean_dist(X_learn, D_learn, threshold, 'threshold');

        %disp(['Wybrane cechy:', num2str(i_features)]);

        [D_classifier, accuracy(j)] = classifier(X_selected, D_learn, X_test(:, i_features), D_test, num_trees);
        %disp(['Dokladnosc:', num2str(accuracy(j))]);
    end
    disp(['Srednia dokladnosc dla klasyfikatora ', num2str(i), ': ', num2str(mean(accuracy))]);
end