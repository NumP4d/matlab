clear;
close all;
clc;

% Liczba pomiarów
N = 20;
% Sygnały pobudzające
U = [sin(1:N); 2*(sin(2:(N+1)))]';
% Parametry rzeczywistego modelu
b = [3, 2.1]';
% Losowe zakłócenia
z = randn(N, 1) * 0.5;
% Pomiary wyjścia modelu na pobudzenia
y = U * b + z;
% estymator parametrów LS:
b_est = (U'*U)^(-1) * U' * y;
disp(b_est);
y_pred = U * b_est;

det(U'*U);

plot(y, 'r');
hold on;
grid on;
plot(y_pred, 'b');
legend('pomiary', 'predykcja modelu');

stosunek_korelacyjny = std(y_pred).^2 / ( std(y).^2 )