function [x, u, J] = opt_dyn(r, q, A, B, N, x0, p0_init, eps) % sekcja 5
    
    p0_1 = p0_init(1);
    p0_2 = p0_init(2);
    if (p0_1 > p0_2)
        disp('Przedzial zle podany');
        return;
    end
    
    % Sprawdzenie istnienia miejsca zerowego
    if (sign(pN(p0_1, r, q, A, B, N, x0) * pN(p0_2, r, q, A, B, N, x0)) == 1)
        disp('Nie ma pewnosci miejsca zerowego w przedziale');
        return;
    end
    p0_przed = [p0_1, p0_2]
    % Jeśli trafiliśmy krańcem przedziału na wystarczające rozwiązanie
    % przerywamy
    [pN_, ip0] = min(abs([pN(p0_przed(1), r, q, A, B, N, x0), pN(p0_przed(2), r, q, A, B, N, x0)]));
    disp(pN_);
    while (abs(pN_) > eps)
        % Wyznaczamy środkowy punkt przedziału
        p0_center = mean(p0_przed);
        % Lewa część przedziału
        if (sign(pN(p0_przed(1), r, q, A, B, N, x0) * pN(p0_center, r, q, A, B, N, x0)) == -1)
            p0_przed = [p0_przed(1) p0_center]
        % Prawa część przedziału
        elseif (sign(pN(p0_przed(2), r, q, A, B, N, x0) * pN(p0_center, r, q, A, B, N, x0)) == -1)
            p0_przed = [p0_center, p0_przed(2)]
        % Dokładnie środek trafił w punkt pN = 0
        else
            p0_przed = [p0_center, p0_center]
        end     
        [pN_, ip0] = min(abs([pN(p0_przed(1), r, q, A, B, N, x0), pN(p0_przed(2), r, q, A, B, N, x0)]));
        disp(pN_);
        %pause;
    end
    
    p0 = p0_przed(ip0);
    % Wyznaczenie wszystkich p i x
    [~, p, x] = pN(p0, r, q, A, B, N, x0);
    % Wyznaczenie sterowań na podstawie p
    u = zeros(1, N);
    for i = 1:N
        u(i) = -2 * B / q * p(i+1);
    end

    % Wyznaczenie wskaźnika jakości
    J = sum(r * x(1:N).^2 + q * u.^2);
end

