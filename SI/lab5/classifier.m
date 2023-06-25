function [D_classifier, accuracy] = classifier(X_learn, D_learn, X_test, D_test, num_trees)
    % Train classifier
    random_forest_model = TreeBagger(num_trees, X_learn, D_learn, 'OOBPrediction','On',...
        'Method','classification');
    D_classifier = random_forest_model.predict(X_test);
    D_classifier = str2num(char(D_classifier));
    accuracy = sum(D_classifier == D_test) ./ length(D_test);
end

