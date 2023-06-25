clear all
close all
clc
% program dzieli wszystkie dane na 2534 przedzia�y, w kt�rych jest sta�e u_main
% plotowanie jest zakomentowane, �eby nie wywali�o kompa xd
% je�li ju� chcecie odkomentowa� to zr�bcie breakpointa do ogl�dania
% kolejnych plot�w, niekt�re s� puste bo u_main mia�o jakiego� dziwnego
% pika

x = load('AoCS_EMM.mat');

u_main = x.x_main_SP;
u_rec = x.x_rec_SP;
u_add = x.x_add1_SP;

y_main = x.v_main;
y_rec = x.v_rec;
y_add = x.v_add1;

plot(u_main);
hold on
plot(u_rec);
plot(u_add);
plot(y_main);
plot(y_rec);
plot(y_add);

last_u_main = u_main(1);
new_u_main = [];
new_u_rec = [];
new_u_add = [];
new_y_main = [];
new_y_rec = [];
new_y_add = [];

tab_u_main = {};
tab_u_rec = {};
tab_u_add
t=[];
plot_counter=0;
lasti = 0; % koniec poprzedniego przedzia�u

for i = 1:337685
    if (u_main(i) == last_u_main)
        new_u_main = [new_u_main u_main(i)];
        new_u_rec = [new_u_rec u_rec(i)];
        new_u_add = [new_u_add u_add(i)];
        new_y_main = [new_y_main y_main(i)];
        new_y_rec = [new_y_rec y_rec(i)];
        new_y_add = [new_y_add y_add(i)];
    else  
%         figure;
%         subplot(2, 1, 1);
%         plot(new_u_main); 
%         hold on;
%         grid on;
%         plot(new_u_rec); 
%         plot(new_u_add); 
%         legend('main', 'rec', 'add');
%         ylabel('x SP, %');
%         subplot(2, 1, 2);
%         plot(new_y_main); 
%         hold on;
%         grid on;
%         plot(new_y_main); 
%         plot(new_y_rec); 
%         plot(new_y_add); 
%         legend('main', 'rec', 'add');
%         xlabel('time, s');
%         ylabel('v, m/s');

        plot_counter=plot_counter+1
        
        if(isempty(t))
            t=[i];
        else
        	t=[t i-lasti]; % d�ugo�ci kolejnych przedzia��w
            lasti = i;
        end
     
        new_u_main = [];
        new_u_rec = [];
        new_u_add = [];
        new_y_main = [];
        new_y_rec = [];
        new_y_add = [];
    end
    last_u_main = u_main(i);
end



    