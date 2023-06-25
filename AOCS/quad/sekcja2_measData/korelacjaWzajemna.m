function [] = korelacjaWzajemna(y, u)

% [] = korelacjaWzajemna(y, u)
%
% Wykre�la korelacj� wzajemn� sygna��w y oraz u w bie��cym oknie wykresu.


% estymuj korelacj� wzajemn� sygna��w - tylko dla przesuni�� w zakresie
% +-10% d�ugo�ci sygna��w, poniewa� dla wi�kszych przesuni�� estymator
% staje si� zbyt niedok�adny:
[kor, przes] = xcorr(y, u);
    % opcja 'unbiased' oznacza obliczenia dla nieobci��onego estymatora
    % korelacji (patrz wyk�ady)

% wykres:
stem(przes, kor);  % korelacj� wykre�lamy "punktowo" (np. stem), a nie 
    % lini� ci�g�� (plot), bo to funkcja okre�lona tylko na dyskretnym 
    % zbiorze argument�w
hold all
plot([0 0], ylim(), 'k');  % pomocniczo: pionowa o� wykresu
title('Korelacja wzajemna y oraz u', 'fontsize', 12);
xlabel('Przesuni�cie \tau');
ylabel('Korelacja wzajemna R_{yu}(\tau)');
