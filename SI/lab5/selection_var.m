function [outX, ivars, variance] = selection_var(X, N_threshold, type)
    var = std(X);
    [var_sorted, i_sorted] = sort(var, 'descend');
    if (strcmp(type, 'n'))
        ivars = i_sorted(1:N_threshold);
    elseif (strcmp(type, 'threshold'))
        ivars = i_sorted(var_sorted >= N_threshold);
    end
    outX = X(:, ivars);
    variance = var(ivars);
end
