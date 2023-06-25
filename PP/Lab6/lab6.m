close all
clc
clear all

x = 0:100;
w = 20;
h1 = 1;
h2 = 1/3;

%% rozdielone, �rednio, na�o�one
p1 = [25 40 50];
p2 = [75 65 60];

%% generowanie piku
figure
hold on
for i=1:length(p1)
    y1 = genPik(h1,w,p1(i),x);
    y2 = genPik(h2,w,p2(i),x);
    y(i,:) = y1 + y2;
    plot(y(i,:))
end
legend('rozdzielone piki', '�rednio rozdzielone', 'na�o�one piki', 'location', 'best')

%% zad 1
k=0.05;
figure
hold on
title('zad1')
for i=1:length(p1)
    y(i,:) = y(i,:) + randn(size(y(i,:)))*k*max(y(i,:));
    plot(y(i,:))
end
legend('rozdzielone piki', '�rednio rozdzielone', 'na�o�one piki', 'location', 'best')

%% zad 2


szerokosc = ci(:, 2) - ci(:, 1);