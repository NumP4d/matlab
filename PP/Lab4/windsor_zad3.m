close all;
clear all;
clc;

N = 10;
m = 2;

eps = 0.001;
max_it = 100;

% Generacja danych
a1 = 1;
a2 = 0;
x = 1:N;
y = a1 * x + a2 + randn(1, N) / 10;

% Adding fat errors
y(1) = y(1) + 10;
y(10) = 0;

y0 = y;

figure;
plot(x, y0, '*');
hold on;
grid on;

X = [ones(1, N);
     x]';
 
x = x';
y = y';

bin = (X' * X)^(-1) * X' * y;
y_p = bin(1) + bin(2) .* x;
ri = y - y_p;

plot(x, y_p, 'k--')

for i = 1:max_it

   bi = bin;
  
   ri_wins = winsorIt(ri, m);
  
   % Generate new y vector
   y = y_p + ri_wins;
    
   bin = (X' * X)^(-1) * X' * y;
   y_p = bin(1) + bin(2) .* x;
   ri = y - y_p;    

   if (abs(bin - bi) < eps)
       break;
   end
   
   plot(x, y_p);
    
end

disp(['Iterations: ', num2str(i)]);

figure;
plot(x, y0, '*');
hold on;
grid on;
plot(x, y_p);
