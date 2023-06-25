clc;
close all;

% regulator Kr(s) = kr * (1 + Td1*s + Td2*s.^2), dyskretny z ró¿nicami
% wstecznymi drugimi

% Parametry regulatora
fs = 16000;
h = 1 / fs;

%kr = 0.00025;
%Td1 = 0.0001;
%Td2 = 0.0001;

%f_diff = @(y, h, i) (3*y(i) - 4 * y(i-1) + y(i-2)) / (2*h);
%f_sec_diff = @(y, h, i) (2*y(i) - 5*y(i-1) + 4*y(i-2) - y(i-3)) / (h.^2);

%K_r = @(e, i) kr * (e + Td1 * f_diff(e, h, i) + Td2 * f_sec_diff(e, h, i));

%Hr_w = @(w) kr * (1 + Td1 * 1i * w + Td2 * (1i * w).^2);

%Ho_w = H_w(1:n/2) .* Hr_w(2*pi*f(1:n/2));
%Ho_w = H_w(1:n/2) .* Hr_w(2*pi*f(1:n/2));

% b = [4, 0.3, 0.2];
% a = [5, 0.2, 0.5];
% b = [4, 0.75, 1];
% a = [5, 25, 25];
% b = [5, 0.2, 1];
% a = [5, 0.75, 1];

%b = [3, 0.01, 0.12];
%a = [8, 0.8, 0.5];

%c = [b(1), b(2), b(3)] / a(1)
%d = [-a(2), -a(3)] / a(1)

%Hr = @(z) (8.138e-14 * z.^2 + 3.255e-13 * z + 8.137e-14) ./ (z.^3 - 3 * z.^2 + 3 * z - 0.9999);

%Hr = @(z) (b(1) + b(2) * z.^(-1) + b(3) * z.^(-2)) ./ (a(1) + b(2) * z.^(-1) + b(3) * z.^(-2));

% kp = 0.5;
% a = [1, 2, 2, 1];
% 
% Hr_s = @(s) kp ./ (a(4) .* s.^3 + a(3) .* s.^2 + a(2) .* s + a(1));
% Ts = 1 ./ fs;
% Hr = @(z) Hr_s(2 ./ Ts .* (1 - z.^(-1)) ./ (1 + z.^(-1)));

% b = [0.1, 2, 15, 0.4, 0.4, 0.02, 1];
% a = [15, 20, 0.1, 0.2, 15, 10, 0.5];
% 
% Hr = @(z) (b(1) + b(2) * z.^(-1) + b(3) * z.^(-2) + b(4) * z.^(-3) + b(5) * z.^(-5) + b(6) * z.^(-6) + b(7) * z.^(-7)) ./ (a(1) + a(2) * z.^(-1) + a(3) * z.^(-2) + a(4) * z.^(-3) + a(5) * z.^(-5) + a(6) * z.^(-6) + a(7) * z.^(-7));
% 
% 
% Hr_w = Hr(exp(1i * 2 * pi * f(1:(n/2))));
% 
% Ho_w = H_w(1:n/2) .* Hr_w;

% wskaznik jakosci - poziom tlumienia halsu
%J_w = 10 * log10(abs(1 + Ho_w).^2);

% % zapas fazy
% [~, i] = min(abs(abs(Ho_w) - 1));
% PM = (pi + angle(Ho_w(i))) * 180 / pi;
% % zapas amplitudy
% [~, i] = min(imag(Ho_w(real(Ho_w) < 0)));
% if (abs(Ho_w(i)) < 1)
%     AM = 20*log10(1 / abs(Ho_w(i)));
% else
%     AM = -1;
% end

% PM = min(pi + angle(Ho_w(abs(abs(Ho_w) - 1) <= 0.05))) * 180 / pi;
% 
% AM = 1 / abs(min(real(Ho_w(imag(Ho_w) <= 0.05))));
% AM = 20*log10(AM);
% %AM = 20*log10(1/abs(Ho_w(i)));
% %AM = 20*log10(1 + real(Ho_w(i)));
% [minJ_w, iminJ_w] = min(J_w);


% [maxJ_w, fmax] = max(J_w);
% 
% disp(['Max noise reduction: ' num2str(maxJ_w), 'dB for f = ', num2str(f(fmax)), 'Hz']);
% disp(['PM: ', num2str(PM), 'deg']);
% disp(['AM: ', num2str(AM), 'dB']);

fun = @ANC_OptimFun;
nonlcon = @ANC_nlinconst;

rng default % For reproducibility
c0 = [1.0, 0.15, 0.2, 1.0, 0, 0];
%c0 = [1, 0.01, 0.12, 0.01, 0.01, 0.01, 0.01, 0.01, 2.5, 0.8, 0.5, 0.01, 5, 0.01, 0.01, 0.01];
lb = [];
ub = [];
%[c, fval, exitflag, output, population, scores] = ga(fun, 6, [], [], [], [], [], [], nonlcon, [], gaoptimset('PopulationSize',100, 'TolFun', 1E-16, 'TolCon', 1E-16));
%[c,fval] = patternsearch(fun, c0, [], [], [], [], lb, ub, nonlcon, psoptimset('TolFun', 1E-14, 'TolCon', 1E-14, 'TolMesh', 1E-14));

%c =  [-1.0743    0.3886   -0.2630    2.5240    0.4735   -2.3714]; %
%najlepsze sterowanka ???


%c = [0.8, 0.15, 0.2, 1.0, 0, 0];

%c = [0.8, 0.15, 0.8, 1.0, -4, 4];

%c = [0.7, 0.15, 0.3, 1.0, -2, 2];

% c = [0.8, 0.15, 0.2, 1.0, -3, 3]; % 7.5 dB maks

%c = [0.4, -0.15, 0.8, 1.0, 0.3, -0.5]; % najfajniejszy duzy zapas stabilnosci

%c = [0.8, 0.15, 0.8, 1.0, -4, 4]; % najlepsze duze tlumienie


% Najnowsze sterowanie do sprawdzenia
%c = [2.6783   -4.7592    2.6689   -0.3691   -2.9821    5.6851];\

% Drugie w miare dobre sterowanie do sprawddzenia
%c = [1.4442   -2.3890    1.2726   -3.7719   -2.4269    3.5060];


% NAJLEPSZE STEROWANIE (SZEROKIE PASMO MIN)
%c = [0.7754   -1.3255    0.6999    2.5776   -0.5200    0.6225];

% DRUGIE NAJLEPSZE (MAX ->)
c = [0.9681   -1.6481    0.8425    2.1800    0.3146   -0.2502];

% 10.5 dB t³umienia (MAX -> przy mniejszym zapasie modu³u)
%c = [0.8085   -1.3832    0.7276    1.1230   -0.7858    0.5956]


z = tf('z',1/16000, 'variable','z^-1');
Hr = @(z) (c(1) + c(2) * z^(-1) + c(3) * z^(-2)) / (1.0 + c(5) * z^(-1) + c(6) * z^(-2));
pzplot(Hr(z));
P = pole(Hr(z));
disp(abs(P));

%disp(exitflag);

%c0 = [1.2, -10, 20, 1, 2, 2];

% c_ = single(c(1:8) / c(9))
% d_ = single(c(10:16) / (-c(9)))

% c(10:end) = 0;

% c0 = [0.2639091, -3.3346875, -1.0284980e+02];
% d0 = [9.0117083  95.9088669];

%c = c0;

%c = 1.0;

%c = [1.0, 0.15, 0.2, 1.0, 0, 0];

%c = [-0.3296, -0.4263, 0.1868, 1.0, -0.4371, -1.1024];

Ho_w = ANC_Ho_w(c);

J_w = 10 * log10(abs(1 + Ho_w).^2);

[constr, ceq] = ANC_nlinconst(c)



% c_ =
% 
%   194.7269   20.2314  169.8811
% 
% d_ = c(5:6) / -c(4)
% 
% d_ =
% 
%     1.8948   -0.8954

% c optim  0.2517    0.9444   -0.0233   -1.8855    0.7602    2.4306
% c_ =
% 
%    -0.1335   -0.5009    0.0124
% 
% d_
% 
% d_ =
% 
%     0.4032    1.2891

k1 = [0.9941, -0.9941];
k2 = [1.0 -0.9883];

e1 = [0.9624 -2.601 2.476 -0.8375];
e2 = [1 -0.6737 -0.5611 0.2473];

%bieguny = [0; roots(k2); roots([1.0, c(5), c(6)])];
%zera = [0; roots(k1); roots(c(1:3))];

bieguny = [0; roots(e2)];
zera = [0; roots(e1)];

%bieguny = roots([1.0, c(5), c(6)]);
%zera = roots(c(1:3));

figure;
hold on;
%grid on;
% plot circle r = 1
th = 0:0.01:2*pi;
x = cos(th);
y = sin(th);
plot(x, y, ':', 'Color', [0.3,0.3,0.3]);
plot([0.000001, -0.000001], [1, -1], ':', 'Color', [0.3,0.3,0.3]);
plot([-1, 1], [0, 0], ':', 'Color', [0.3,0.3,0.3]);
scatter(real(bieguny), imag(bieguny), 40, 'bx');
scatter(real(zera), imag(zera), 40, 'bo');
xlabel('Oœ rzeczywista');
ylabel('Oœ urojona');
xlim([-1 1]);
ylim([-1 1]);

% k = 20;
% x = [0; 1; zeros(k-1, 1)];
% y1 = zeros(k+1, 1);
% y1_n = @(n) k1(1) * x(n) +  k1(2) * x(n-1) - k2(2) * y1(n-1);
% y2 = zeros(k+2, 1);
% y2_n = @(n) c(1) * y1(n-1) + c(2) * y1(n-2) + c(3) * y1(n-3) - c(5) * y2(n-1) - c(6) * y2(n-2);
% 
% for i = 3:(k+2)
%     y1(i-1) = y1_n(i-1);
%     y2(i) = y2_n(i);
% end

H_reg = Hr(z) * (k1(1) + k1(2) * z^(-1)) / (k2(1) + k2(2) * z^(-1));

[h, t] = impz(e1, e2, 20, 16000);

figure;
stem(t*1000, h);
xlim([0, 1.2]);
grid on;
xlabel('Czas, ms');
ylabel('Amplituda');

figure;
impz(e1, e2, 20, 16000);


%impz(H_reg);

figure;
hold on;
grid on;
% plot nyquist of open-loop model
%scatter(real(Ho_w), imag(Ho_w), 'b.');
scatter(real(Ho_w(J_w >= 6)), imag(Ho_w(J_w >= 6)), 'g.');
scatter(real(Ho_w(J_w < 6)), imag(Ho_w(J_w < 6)), 'r.');
% plot circle r = 1
th = 0:0.01:2*pi;
x = cos(th);
y = sin(th);
plot(x, y, 'k:');
xlabel('$Re(H(e^{j\omega}))$', 'Interpreter', 'latex');
ylabel('$Im(H(e^{j\omega}))$', 'Interpreter', 'latex');
%title('Nyquist chart of open-loop model Ho');

figure;
%semilogx(f(J_w < 6), J_w(J_w < 6), 'r');
semilogx(f(1:348), J_w(1:348), 'r');
grid on;
hold on;
semilogx(f(493:n/2), J_w(493:end), 'r');
semilogx(f(J_w >= 6), J_w(J_w >= 6), 'g');
xlim([f(1), f(n/2)]);
%scatter(real(H_w(1:(n/2))), 20*log10(abs(H_w(1:(n/2))).^2), 'b.');
xlabel('Czêstotliwoœæ, Hz');
ylabel('T³umienie zak³óceñ, dB');

% figure;
% hold on;
% grid on;
% scatter(real(Ho_w), imag(Ho_w), 'b.');
% % plot circle r = 1
% th = 0:0.01:2*pi;
% x = cos(th);
% y = sin(th);
% plot(x, y, 'k--');
% xlabel('Re(H(jw))');
% ylabel('Im(H(jw))');