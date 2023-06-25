function [outX, ivars, mean_dist] = selection_mean_dist(X, D, N_threshold, type)
    means0 = mean(X(D == 0, :));
    means1 = mean(X(D == 1, :));
    diff = abs(means1 - means0);
    [diff_sorted, i_sorted] = sort(diff, 'descend');
    if (strcmp(type, 'n'))
        ivars = i_sorted(1:N_threshold);
    elseif (strcmp(type, 'threshold'))
        ivars = i_sorted(diff_sorted >= N_threshold);
    end
    outX = X(:, ivars);
    mean_dist = diff(ivars);
end