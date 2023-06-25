% model instalacji hydraulicznej na potrzeby PBL 2019 bez si�ownika pr�ba
% identyfikacji parametr�w (op�r turbulentny)
%dane= load ('d:\pbl\Matlab\Obrobione\P1_data_o_01.txt');
%zak�adamy zidentyfikowany przep�yw ca�kowity
Flc=5.7667e-05; Flr=Flc; % [m3/s] 3.46[l/min] przep�yw ca�kowity
Tt=0.5; Tr=2.5; % [s] dynamika przyrostu co�nienia
Ss=0.02;  % [m2] powierzchnia t�oka
Rw=50000000;  % [Pa*s/m3] op�r w�y do si�ownika
Cs=1/100000; % wsp�czynnik sztywno�ci spr�yny si�ownika [N/m]
Pp=0; Przel=0; Flsp=0; P=Pp; Pxp=P; % ci�nienie pocz�tkowe [MPa]
u1=10; Rr=0; xmax=0.2; xp=0;% [m]
Flt=0; Fls=0; Ps=0; Fn=0; Flsip=0; Fnip=0; % pocz�tkowe przep�ywy t�oka s� zerowe.
WP=[]; Wt=[]; WFlr=[]; Faza=1; Fbelki=0; WFazy=[]; Wx=[]; WFnac=[]; WFni=[];
WFlsi=[]; WFls=[];
St_czas_s=Cs*Rw*Ss^2  % zast�pcza sta�a czasowa si�ownika, 
m=8000; t=0; dt=0.02;  % w [s]
 for i=1:m
     t=t+dt;
 Rr=proc_Rzt(u1);
 if i==1000
     u1=20;
 elseif i==3000
         u1=30;
     end
 if Rr<0
     Rr=0;
 end
 % ci�nienie na zaworze
    Flr = Flc;
     P=Pp+(dt/Tr)*(Rr*(Flr^2)-Pp); %[MPa]
     Przel=P*10^6; %[Pa]
     dp_dt=(P-Pp)/dt;
 % przep�ywy
    x=xp+(dt/St_czas_s)*(-xp+Cs*(Przel*Ss-Fnip));%[m] si�y w N, ci�nienia w Pa
     if x<0
        x=0;
     elseif x>xmax
        x=xmax;
     end
    xwe=x*1000; %[mm]
    Fnac=37.393*xwe; % reakcja belki w [kN]
    Fn=Fnac*1000; % [N]
    Fni=Fnip+(dt/(1*Tt))*(Fn-Fnip);
    Fls=Ss*(x-xp)/dt; % [m3/s]
    Flsi=Flsip+(dt/(2*Tt))*(Fls-Flsip);  
    if Flsi<0
        Flsi=0;
    end
    Flr=Flc;
     if Flr<0
         Flr=0;
     end
 %%%%% przypisanie stan�w poprzednich
     Pp=P; xp=x; Fnip=Fni;Flsip=Flsi;
     WP(i)=P; Wt(i)=t; Wx(i)=x; WFnac(i)=Fnac; WFlsi(i)=Flsi;
     WFlr(i)=Flr;  WFni(i)=Fni;WFls(i)=Fls;
     
 end
Fzcis=Przel*Ss
Fnip
Fn
figure
 plot(Wt,WP);
 title('cis�ienie na zaworze MPa');
 grid on
  figure
  plot(Wt,Wx*10^(3));
 title('przesuni�cie t�oka mm');
 grid on
 figure
  plot(Wt,WFnac);
 title('reakcja podpory kN');
 grid on
figure
  plot(Wt,WFni);
 title('si��a filtrowana');
 grid on
 figure
  plot(Wt,WFlsi);
 title('przep�yw t�oka filtrowany');
 grid on