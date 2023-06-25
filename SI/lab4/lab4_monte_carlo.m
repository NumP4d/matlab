clear;
close all;
clc;

csv0 = csvread('0.csv');
csv2 = csvread('3.csv');

csv0(:, 65) = -1;
csv2(:, 65) = 1;

A = [csv0; csv2];
X = A(:, 1:(end-1));
D = [csv0(:, 65); csv2(:, 65)];

N = 3;
N_monte_carlo = 50;

acc_arb = zeros(N_monte_carlo, length(N));
acc_pca = zeros(N_monte_carlo, length(N));
acc_pls = zeros(N_monte_carlo, length(N));
acc_pls_norm = zeros(N_monte_carlo, length(N));

for j = 1:length(N)

    disp(['Extracting N = ', num2str(N(j)), ' features.']);

    for i = 1:N_monte_carlo

        % Split data into learning and testing set
        k = size(X, 1);
        itest = (rand(k, 1) < 1/3);
        ilearn = ~itest;

        X_learn = X(ilearn, :);
        D_learn = D(ilearn, :);
        X_test = X(itest, :);
        D_test = D(itest, :);

        % Arbitral method (first N features)
        acc_arb(i, j) = arbitral_classifier(X_learn, D_learn, X_test, D_test, N(j));

        % PCA method
        acc_pca(i, j) = pca_classifier(X_learn, D_learn, X_test, D_test, N(j));

        % PLS method
        acc_pls(i, j) = pls_classifier(X_learn, D_learn, X_test, D_test, N(j));

        % PLS normalized method  
        acc_pls_norm(i, j) = pls_norm_classifier(X_learn, D_learn, X_test, D_test, N(j));
    end

    disp(['Arbitral accuracy: ', num2str(mean(acc_arb(:, j)))]);
    disp(['     PCA accuracy: ', num2str(mean(acc_pca(:, j)))]);
    disp(['     PLS accuracy: ', num2str(mean(acc_pls(:, j)))]);
    disp(['PLS norm accuracy: ', num2str(mean(acc_pls_norm(:, j)))]);

end

figure;
plot(N, mean(acc_arb), 'y');
hold on;
grid on;
plot(N, mean(acc_pca), 'b');
plot(N, mean(acc_pls), 'r');
plot(N, mean(acc_pls_norm), 'g');

xlabel('N features');
ylabel('Accuracy');
legend('arbitral', 'PCA', 'PLS', 'PLS normalized');