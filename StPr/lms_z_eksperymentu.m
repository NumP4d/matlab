clc;
close all;

% NOT CLEAR ALL!!

% Próbkowanie wymuszenia oraz wyjścia:
Tstart = 300;
Tp = 1;
Tend = tout(end);
ind = logical(sum((tout == Tstart:Tp:Tend), 2));
u = p100(ind) - p100(tout == Tstart - Tp);
y = x2(ind) - x2(tout == Tstart - Tp);
y0 = x2(tout == Tstart - Tp);

% Model układu: Ho(z^-k) = z^(-1) * B(z^-1) / A(z^-1)
k  = 1;
dB = 2;
dA = 3;
un = [zeros(k + dB, 1); u];
yn = [zeros(dA, 1); -y];
fi = zeros(length(y), dB + dA + 1);
% Tworzymy wektory theta:
for i = (1+dA):(length(y)+dA)
    m = i - dA;
    fi(m, :) = [flip(yn((i-dA):(i-1))'), flip(un((i-k-dB):(i-k))')];
end

theta = (fi' * fi)^(-1) * fi' * y;

y_model = fi * theta;
sq_err = sum(y_model - y).^2;
disp(['Blad predykcji jednokrokowej LMS: ', num2str(sq_err)]);

figure;
plot(Tstart:Tp:Tend, y, 'r');
hold on;
grid on;
stairs(Tstart:Tp:Tend, y_model, 'b');
xlim([Tstart, Tend]);

% Tworzymy wektory theta:
% parametry wielomianów:
a = [1; theta(1:dA)];
b = theta((dA+1):end);
ysim = zeros(length(u) + 1 +dA, 1);
for i = (1+dA):(length(u) + dA)
    ysim(i) = - a(2) * ysim(i-1) - a(3) * ysim(i-2) - a(4) * ysim(i-3) ...
              + b(1) * un(i-1)   + b(2) * un(i-2)   + b(3) * un(i-3);
end
stairs(Tstart:Tp:Tend, ysim((1+dA):(end-1)), 'g');
sq_err = sum(ysim((1+dA):(end-1)) - y).^2;
disp(['Blad identyfikacji LMS: ', num2str(sq_err)]);
for L = 1:20
    W = zeros(length(y), dB + dA + 1);
    % Tworzymy wektory theta:
    for i = (1+dA):(length(y)+dA)
        m = i - dA;
        W(m, :) = [flip(ysim((i-dA):(i-1))'), flip(un((i-k-dB):(i-k))')];
    end
    theta = (W' * fi)^(-1) * W' * y;
    a = [1; theta(1:dA)];
    b = theta((dA+1):end);
    ysim = zeros(length(u) + 1 +dA, 1);
    for i = (1+dA):(length(u) + dA)
        ysim(i) = - a(2) * ysim(i-1) - a(3) * ysim(i-2) - a(4) * ysim(i-3) ...
                  + b(1) * un(i-1)   + b(2) * un(i-2)   + b(3) * un(i-3);
    end
end

y_model = fi * theta;
sq_err = sum(y_model - y).^2;
disp(['Blad predykcji jednokrokowej IV: ', num2str(sq_err)]);
sq_err = sum(ysim((1+dA):(end-1)) - y).^2;
disp(['Blad identyfikacji IV: ', num2str(sq_err)]);

stairs(Tstart:Tp:Tend, ysim((1+dA):(end-1)), 'k--');

legend('rzeczywisty przebieg', 'predykcja jednokrokowa', 'model LMS', 'model IV');

figure;
zeros_t = roots(b);
poles_t = roots(a);
scatter(real(zeros_t), imag(zeros_t), 'o');
hold on;
grid on;
scatter(real(poles_t), imag(poles_t), 'x');



f = zeros(k-1, 1);
%g = zeros(length(a1)-1, 1);
g = zeros(length(a)-1, 1);
f(1) = 1 / a(1);
g(1) = -a(2) * f(1);
g(2) = -a(3) * f(1);
g(3) = -a(4) * f(1);