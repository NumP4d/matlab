function [acc] = pls_classifier(X_learn, D_learn, X_test, D_test, N)
    % PLS method
    [Xloadings,~,Xscores] = plsregress(X_learn,D_learn, N, 'CV', 10);
    
    % Naive Bayess classification method
    cl_naive = NaiveBayess;
    cl_naive = cl_naive.Train(Xscores, D_learn);
    % feature extraction
    mu = mean(X_learn);
    scoreTest = (X_test - mu) /  Xloadings';
    [d_naive] = cl_naive.Classify(scoreTest);
    acc = accuracy(d_naive, D_test);
end

