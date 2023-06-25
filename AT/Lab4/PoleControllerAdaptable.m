function [u_n] = PoleControllerAdaptable(u, y, w, bi, alfa)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    b = [0, bi(1), bi(2)];
    a = [1, bi(3), bi(4)];

    Km = (1 + alfa) / sum(b);

    a0 = a(1);
    a1 = a(2);
    a2 = a(3);
    
    b0 = b(2);
    b1 = b(3);
    
    f0 = 1;
    g0 = (-a2 - a1 * alfa + a1^2 + b0 * a2 * alfa / b1 - b0 * a2 * a1 / b1) / (-a1 * b0 + b0^2 * a2 / b1 + b1);
    f1 = alfa - a1 - b0 * g0;
    g1 = - a2 * f1 / b1;
    
    R = [f0, f1];
    T = Km;
    S = [g0, g1];

    ui = zeros(1, length(R) - 1);
    yi = zeros(1, length(S));
    for i = 0:(length(ui)-1)
        if (i < (length(u) - 1))
            ui(i + 1) = u(end - i);
        else
            ui(i + 1) = u(1);
        end
    end
    for i = 0:(length(yi)-1)
        if (i < (length(y) - 1))
            yi(i + 1) = y(end - i);
        else
            yi(i + 1) = y(1);
        end
    end
    
    w_f = w * T;
    y_f = yi(1) * S(1) + yi(2) * S(2);
    err = w_f - y_f;
    u_n = (err - R(2) * ui(1)) / R(1);
    
    %u_n = (T * w - S(1) * yi(1) - S(2) * yi(2) - R(2) * ui(1)) / R(1);
end