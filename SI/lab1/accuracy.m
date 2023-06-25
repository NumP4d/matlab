function [acc, TP, TN, FP, FN] = accuracy(d_classifier, d_test)
    %classes = unique(d_test)
    classes = [-1; 1];
    TP = sum(((d_classifier == d_test) & (d_test == max(classes))));
    TN = sum(((d_classifier == d_test) & (d_test == min(classes))));
    FP = sum(((d_classifier ~= d_test) & (d_test == min(classes))));
    FN = sum(((d_classifier ~= d_test) & (d_test == max(classes))));
    
    acc = (TP + TN) ./ (TP + TN + FP + FN);
end