function [y_prediction] = ModelPlant(fi, bi)    
    y_prediction = fi' * bi;
end