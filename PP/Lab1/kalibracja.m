function [b, c] = kalibracja(xw, yw, type)

    if (type == "stale")
        W = diag(ones(size(xw)));
    else
        waga = xw.^2;
        waga(waga == 0) = 0.0001;
        W = diag(1 ./ waga);
    end

    X = [ones(size(xw)), xw];
    
    disp(['Wyznacznik macierzy: ', num2str(det(X' * W * X))]);
    
    b = (X' * W * X)^(-1) * X' * W * yw;
    
    c = [-b(1) / b(2); 1 / b(2)];
end