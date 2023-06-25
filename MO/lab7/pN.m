function [pN, p, x] = pN(p0, r, q, A, B, N, x0)
    x = zeros(1, N + 1); % indeksy od 1
    p = zeros(1, N + 1); % indeksy od 1
    p(1) = p0;
    x(1) = x0;
    for i = 1:N
        % Wyznaczanie pi+1:
        p(i+1) = (p(i) - 2 * x(i) / r) / A;
        % Wyznaczanie xi+1:
        x(i+1) = A * x(i) - 2 * B^2 / q * (p(i) - 2 * x(i) / r) / A;
    end
    pN = p(end);
end

