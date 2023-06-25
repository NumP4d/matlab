function [y] = J_m(u)

    x = zeros(1, 7);
    x(1) = 50;
    for i = 1:6
        x(i+1) = 2*x(i) + 7 * u(i);
    end
    y = 1 / 2 * sum(5 * x(1:6).^2 - u(i).^2);

end

