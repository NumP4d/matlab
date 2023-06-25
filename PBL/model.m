close all
clc
clear all

T_koniec = 400;
dt = 0.2;
t = 0:dt:T_koniec;
x = zeros(size(t));
P = zeros(size(t));
Fn = zeros(size(t));
proc = zeros(size(t));
dx = 0;
%zak�adamy zidentyfikowany przeo�yw ca�kowity
V=5.7667e-05; % [m3/s] 3.46[l/min] przep�yw ca�kowity
%zmiany Rr 0 do 6.0000e+10 [Pa*s/m3]
Tt=0.5; % [s] sta�a czasowa t�umika
Tr=2.5; % [s] sta�a czasowa zaworu (dynamika przyrostu ci�nienia)
Ss=0.02;  % [m2] powierzchnia t�oka
St=0.0039; % [m2] powierzchnia t�umika
ymax=0.003;  % [m]  maksymalny zakres y t�umika
Vct=St*ymax; % [m3] ca�kowita pojemno�� t�umika
Rw=50000000;  % [Pa*s/m3] op�r w�y do si�ownika
Cs=1/10000; % wsp�czynnik sztywno�ci spr�yny si�ownika [N/m]
faza = 1;
faza_vector = [];
plyniecie = 1;

for i = 1:length(t)
    
    if proc(i)<72
        Rr = 4.8231*proc(i).^5-721.59*proc(i).^4+41255*proc(i).^3-9.5681e5*proc(i).^2+1.059e7*proc(i)-1.5468e6;
    elseif (proc(i)>=72) && (proc(i)<=78)
        Rr = 2.7464e6*proc(i).^3-5.9127e8*proc(i).^2+4.2506e10*proc(i)-1.0193e12;
    else
        Rr = -5.1492e5*proc(i).^3+1.2894e8*proc(i).^2-1.0237e10*proc(i)+2.606e11;
    end
    
    if(dx>0)
        Ft = -1000;
    elseif(dx<0)
        Ft = 1000;
    else
        Ft = 0;
    end

    switch(faza)
        case 1
            Fn(i) = 37.973 * x(i)*1000;
            if (Fn(i) > 40)
                faza = 2;
            end
        case 2
            Fn(i) = 19.029 * x(i)*1000 + 21.296;
            if (Fn(i) > 130)
                faza = 3;
            end
        case 3
            Fn(i) = 13.841 * x(i)*1000 + 50.869;
            if (Fn(i) > (170 - plyniecie))
                faza = 4;
            end
        case 4
            Fn(i) = -5.9 * x(i)*1000 + 220.96;
            if (Fn(i) > (170 + plyniecie))
                faza = 5;
            end  
        case 5
            %disp('Zniszczenie belki!')
            Fn(i) = -73.267 * x(i)*1000 + 832.8;
    end
    faza_vector = [faza_vector; faza];
    Fn(i) = Fn(i)*1000;
    Fn = 0;
    Fs=P(i)*Ss;
    x(i+1) = ((-x(i) + Cs*(Fs+Ft-Fn(i)))/(Cs*Rw*(Ss^2)))*dt + x(i);
    dx = (x(i+1) - x(i))/dt;
    dx = 0;

    P(i+1) = (-P(i)/Tr + ((V - Ss*dx)^2)*Rr/Tr)*dt + P(i);
    
    if (mod(i, round(length(t) / 10)) == 1)
        proc(i+1) = proc(i) + 10;
    else
        proc(i+1) = proc(i);
    end
    %proc(i) = 100;
    % Regulacja
%     if (proc(i) < 100)
%         proc(i+1) = proc(i)+1;
%     end
end

figure;
subplot(2, 1, 1);
plot(t, P(1:(end-1)));

subplot(2, 1, 2);
plot(t, x(1:end-1)*1000);