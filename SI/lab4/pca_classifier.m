function [acc,latent] = pca_classifier(X_learn, D_learn, X_test, D_test, N)
    % PCA method
    [coeff,score,latent,~,~,mu] = pca(X_learn);

    % Naive Bayess classification method
    cl_naive = NaiveBayess;
    cl_naive = cl_naive.Train(score(:, 1:N), D_learn);
    % feature extraction
    scoreTest = (X_test-mu) / coeff';
    [d_naive, ~] = cl_naive.Classify(scoreTest(:, 1:N));
    acc = accuracy(d_naive, D_test);
end

