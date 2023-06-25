function [outX, ivars, acc] = wrapper(X_learn_full, D_learn_full, X_learn, D_learn, X_test, D_test, N1, N2, num_trees, filttype)
    if (strcmp(filttype, 'var'))
        [~, i_features] = selection_var(X_learn_full, N1, 'n');
    elseif (strcmp(filttype, 'mean_dist'))
        [~, i_features] = selection_mean_dist(X_learn_full, D_learn_full, N1, 'n');
    end
    for k = 1:(N1-N2)
        accuracy = zeros(1, N1-k);
        for i = 1:(N1-k)
            i_features_ = i_features(i_features ~= i_features(i));
            [~, accuracy(i)] = classifier(X_learn(:, i_features_), D_learn, X_test(:, i_features_), D_test, num_trees);
        end
        [~, i_sorted] = sort(accuracy, 'descend');
        disp(i_features(i_sorted));
        [maxacc, imax] = max(accuracy);
        disp(['Actual acc: ', num2str(maxacc)]);
        i_features = i_features(i_features ~= i_features(imax));
    end
    
    acc = max(accuracy);
    ivars = i_features;
    outX = X_learn(ivars);
end

