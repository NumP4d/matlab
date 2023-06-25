function [d_test, prob_test] = bayess(A_learn, d_learn, A_test, k)
%BAYESS Summary of this function goes here
%   Detailed explanation goes here
    d_test = zeros(size(A_test, 1));
    prob_test = zeros(size(A_test, 1));
    apriori_a = sum(d_learn == -1);
    apriori_b = sum(d_learn == 1);
    dist = zeros(size(A_learn, 1));
    for i = 1:size(A_test, 1)
        for j = 1:size(A_learn, 1)
            dist(j) = pdist([A_test(i, :); A_learn(j, :)], 'euclidean');
        end
        [~, index] = sort(dist, 'descend');
        knn_classes = d_learn(index(1:k));
        % calculate probablity
        prob_a = sum(knn_classes == -1) / k * apriori_a;
        prob_b = sum(knn_classes == 1) / k * apriori_b;
        if (prob_a >= prob_b)
            d_test(i) = -1;
            prob_test(i) = prob_a;
        else
            d_test(i) = 1;
            prob_test(i) = prob_b;
        end
    end
end

