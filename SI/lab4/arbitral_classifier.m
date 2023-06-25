function [acc] = arbitral_classifier(X_learn, D_learn, X_test, D_test, N)
    % Naive Bayess classification method
    cl_naive = NaiveBayess;
    cl_naive = cl_naive.Train(X_learn(:, 1:N), D_learn);
    [d_naive, ~] = cl_naive.Classify(X_test(:, 1:N));
    acc = accuracy(d_naive, D_test);
end

