function [u_n] = PoleControllerIndirect(u, y, w, R, T, S)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
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
    
    %disp(ui);
    %disp(yi);
    
    w_f = w * T;
    %disp(w_f);
    y_f = yi(1) * S(1) + yi(2) * S(2);
    %disp(y_f);
    err = w_f - y_f;
    %disp(err);
    u_n = (err - R(2) * ui(1)) / R(1);
    
    
    u_n = (T * w - S(1) * yi(1) - S(2) * yi(2) - R(2) * ui(1)) / R(1);
end

