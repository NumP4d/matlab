clear;
close all;
clc;

%rng('default');

csv0 = csvread('0.csv');
csv2 = csvread('3.csv');

csv0(:, 65) = -1;
csv2(:, 65) = 1;

N = 3;

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

[coeff,score,latent,~,explained,mu] = pca(X_learn);

figure;
plot(latent);
grid on;
xlim([1, 64]);
xlabel('feature');
ylabel('variance');

figure;
scatter3(X_learn(D_learn == -1, 1), X_learn(D_learn == -1, 2), X_learn(D_learn == -1, 3), 'b.');
hold on;
scatter3(X_learn(D_learn == 1, 1), X_learn(D_learn == 1, 2), X_learn(D_learn == 1, 3), 'r.');

figure;
scatter3(score(D_learn == -1, 1), score(D_learn == -1, 2), score(D_learn == -1, 3), 'b.');
hold on;
scatter3(score(D_learn == 1, 1), score(D_learn == 1, 2), score(D_learn == 1, 3), 'r.');

figure;
scatter(score(D_learn == -1, 1), score(D_learn == -1, 2), 'b.');
hold on;
scatter(score(D_learn == 1, 1), score(D_learn == 1, 2), 'r.');
xlabel('x1');
ylabel('x2');
grid on;

% Naive Bayess classification method
cl_naive = NaiveBayess;
cl_naive = cl_naive.Train(X_learn, D_learn);
[d_naive, perror_naive] = cl_naive.Classify(X_test);
acc_naive = accuracy(d_naive, D_test)

% Naive Bayess classification method
cl_naive = NaiveBayess;
cl_naive = cl_naive.Train(score, D_learn);
% ekstrakcja cech
% test czy poprawnie odtwarzamy zbiór cech:
errorpca = max(max(abs(score - (X_learn - mu)*coeff)))
scoreTest = (X_test-mu)*coeff;
[d_naive, perror_naive] = cl_naive.Classify(scoreTest);
acc_naive = accuracy(d_naive, D_test)

disp('Po redukcji do k = 3');

k = 3;

% Naive Bayess classification method
cl_naive = NaiveBayess;
cl_naive = cl_naive.Train(X_learn(:, 1:k), D_learn);
[d_naive, perror_naive] = cl_naive.Classify(X_test(:, 1:k));
acc_naive = accuracy(d_naive, D_test)

% Naive Bayess classification method
cl_naive = NaiveBayess;
cl_naive = cl_naive.Train(score(:, 1:k), D_learn);
% ekstrakcja cech
scoreTest = (X_test-mu)*coeff;
[d_naive, perror_naive] = cl_naive.Classify(scoreTest(:, 1:k));
acc_naive = accuracy(d_naive, D_test)

% Metoda ekstrakcji PLS

% [XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] = plsregress(X_learn,D_learn);
% score = XS;
% 
% figure;
% scatter3(score(D_learn == -1, 1), score(D_learn == -1, 2), score(D_learn == -1, 3), 'b.');
% hold on;
% scatter3(score(D_learn == 1, 1), score(D_learn == 1, 2), score(D_learn == 1, 3), 'r.');
% 
% % Naive Bayess classification method
% cl_naive = NaiveBayess;
% cl_naive = cl_naive.Train(XS, D_learn);
% % ekstrakcja cech
% mu = mean(X_learn);
% errorpls = score - (X_learn - mu) * XL;
% %scoreTest = (X_test - mu)*XL;
% [d_naive, perror_naive] = cl_naive.Classify(scoreTest);
% acc_naive = accura/ cy(d_naive, D_test)

%  2 podejście

[n,p] = size(X_learn);
[Xloadings,Yloadings,Xscores,Yscores,betaPLS] = plsregress(X_learn,D_learn,3, 'CV', 10);
score = Xscores;
yfitPLS = [ones(n,1) X_learn]*betaPLS;
figure;
scatter3(score(D_learn == -1, 1), score(D_learn == -1, 2), score(D_learn == -1, 3), 'b.');
hold on;
scatter3(score(D_learn == 1, 1), score(D_learn == 1, 2), score(D_learn == 1, 3), 'r.');

figure;
scatter(score(D_learn == -1, 1), score(D_learn == -1, 2), 'b.');
hold on;
scatter(score(D_learn == 1, 1), score(D_learn == 1, 2), 'r.');
xlabel('x1');
ylabel('x2');
grid on;

% Naive Bayess classification method
cl_naive = NaiveBayess;
cl_naive = cl_naive.Train(Xscores, D_learn);
% ekstrakcja cech
mu = mean(X_learn);
errorpls = max(max(abs(Xscores - (X_learn - mu) / Xloadings')))
%scoreTest = (X_test - mu)' \ Xloadings;
scoreTest = (X_test - mu) /  Xloadings';
[d_naive, perror_naive] = cl_naive.Classify(scoreTest);
acc_naive = accuracy(d_naive, D_test)

% 3 podejście
%normalize X_learn and D_learn
[X0_learn, mu_X0, sigma_X0] = zscore(X_learn);
%[D0_learn, mu_D0, sigma_D0] = zscore(D_learn);
[n,p] = size(X0_learn);
[Xloadings,Yloadings,Xscores,Yscores,betaPLS] = plsregress(X0_learn,D_learn,3, 'CV', 10);
score = Xscores;

% figure;
% scatter3(score(D_learn == -1, 1), score(D_learn == -1, 2), score(D_learn == -1, 3), 'b.');
% hold on;
% scatter3(score(D_learn == 1, 1), score(D_learn == 1, 2), score(D_learn == 1, 3), 'r.');

% Naive Bayess classification method
cl_naive = NaiveBayess;
cl_naive = cl_naive.Train(Xscores, D_learn);
% ekstrakcja cech
errorpls = max(max(abs(Xscores - ((X_learn - mu_X0) ./ sigma_X0) / Xloadings')))
% %scoreTest = ((X_test - mu_X0) ./ sigma_X0)' \ Xloadings;
scoreTest = ((X_test - mu_X0) ./ sigma_X0) /  Xloadings';
%scoreTest = ((X_test - mean(X_test)) ./ std(X_test)) / Xloadings';
[d_naive, perror_naive] = cl_naive.Classify(scoreTest);
acc_naive = accuracy(d_naive, D_test)

figure;
scatter(score(D_learn == -1, 1), score(D_learn == -1, 2), 'b.');
hold on;
scatter(score(D_learn == 1, 1), score(D_learn == 1, 2), 'r.');
xlabel('x1');
ylabel('x2');
grid on;


[X0_learn, mu_X0, sigma_X0] = zscore(X_learn);
[coeff,score,latent,~,explained,mu] = pca(X0_learn);

    % Naive Bayess classification method
    cl_naive = NaiveBayess;
    cl_naive = cl_naive.Train(score(:, 1:3), D_learn);
    % feature extraction
    scoreTest = ((X_test - mu_X0) ./ sigma_X0) / coeff';
    [d_naive, ~] = cl_naive.Classify(scoreTest(:, 1:3));
    acc = accuracy(d_naive, D_test)
    
figure;
scatter(score(D_learn == -1, 1), score(D_learn == -1, 2), 'b.');
hold on;
scatter(score(D_learn == 1, 1), score(D_learn == 1, 2), 'r.');
xlabel('x1');
ylabel('x2');
grid on;
