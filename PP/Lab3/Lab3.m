close all;
clear;
clc;

mip=5;sigp=0.2;
miq=9;sigq=0.2;
epsilon=1 - 0.12; 

N=24;
p=0;
q=0;
x=[];
for i=1:N
   if rand>epsilon 
       x=[x;randn*sigp+mip];
       p=p+1; 
   else
       x=[x; randn*sigq+miq];
       q=q+1; 
   end % realizacja modelu Jeffreysa
end
n=zeros(size(x));
x=sort(x);
figure;
hold on;
lw=3;
xx=linspace(mip-4*sigp,mip+4*sigp,100);
plot(xx,(1-epsilon)*normpdf(xx,mip,sigp),'r','LineWidth',lw); % teoretyczny przebieg rozkładu P(x)
xx=linspace(miq-4*sigq,miq+4*sigq,100);
plot(xx,epsilon*normpdf(xx,miq,sigq),'g','LineWidth',lw); % teoretyczny przebieg rozkładu Q(x)
plot(x,n,'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
grid on;
a=axis;
a(3)=-0.2;axis(a);
title(['P(x): ' num2str(p) '   Q(x): ' num2str(q)]);
legend('P(x)','Q(x)','Próbka'); xlabel(['x= ' num2str(x',3)]);

[wy, x_cenzura] = dixon(x, 'min');

disp(wy);