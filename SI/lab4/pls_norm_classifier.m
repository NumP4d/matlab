function [acc] = pls_norm_classifier(X_learn, D_learn, X_test, D_test, N)
    %normalize X_learn
    [X0_learn, mu_X0, sigma_X0] = zscore(X_learn);
    
    % PLS method
    [Xloadings,~,Xscores] = plsregress(X0_learn,D_learn, N, 'CV', 10);
    
    % Naive Bayess classification method
    cl_naive = NaiveBayess;
    cl_naive = cl_naive.Train(Xscores, D_learn);
    % feature extraction
    scoreTest = ((X_test - mu_X0) ./ sigma_X0) /  Xloadings';
    %scoreTest = ((X_test - mean(X_test)) ./ std(X_test)) /  Xloadings';
    [d_naive, ~] = cl_naive.Classify(scoreTest);
    acc = accuracy(d_naive, D_test);
end

