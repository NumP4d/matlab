clear all
close all
U = 0; E = 0; Ui = 0; Y = 0;%control signal, error, integral part
X = [0,0];
Tp = 0.01;
Ts = 0.1;
SP = 2;
loopPlant = 100;
loopControl = 500;
time = 0:loopPlant^-1:loopControl;
outX1 = [0]; %statespace
outX2 = [0]; %statespace
outY = [0]; %output
outE = [0]; %error
outU = [0]; %control 
outR = [0]; %pole placement
outS = [0]; %pole placement
outT = [0]; %pole placement
outSP = [0]; %setpoint
outYhorizon = [0]; %output with control horizon
noise = randn(loopControl+1,1)' + 0; %white noise, sigma * rand + mu
alfa = -0.5; % tuning parameter

%% DEFAULT PLANT + DISCRETE PARAMETERS

s = tf('s');
trans = 5 / ( (10*s + 1)*(15*s + 1));
transDisc = c2d(trans,1); % cont 2 disc
transDisc = filt(transDisc.Numerator,transDisc.Denominator,1); % to z^-1 notation
transDiscParam = [cell2mat(transDisc.denominator) cell2mat(transDisc.numerator)]';
transDiscParam(4) = []; transDiscParam(1) = []; 
%{
[z,p,k] = zpkdata(trans)
RLSP = nyquistoptions;
RLSP.ShowFullContour = 'off';
nyquistplot (trans,RLSP);
[A, B, C, D] = ssdata(trans)
%}
k = 5;
T1 = 10;
T2 = 15;

A = [-1/T1, 0 ]; % x1 equation coefficients
B = [1/T2, -1/T2]; % x2 equation coefficients
C = k/T1;        % u equation coefficients

%% RLS METHOD INIT

RLSb = [0 0 0 0]';
RLSa = [1 1 1 1] * 10000;
RLSP = diag(RLSa);
RLSParam = zeros(4,loopControl);
RLSY = [0,0.1,0.2,0.3];
RLSalfa = 0.7; % forgetting factor

%% CONTROL LOOP

for i = 1:loopControl
    A = [-1/T1, 0 ]; % x1 equation coefficients
    B = [1/T2, -1/T2]; % x2 equation coefficients
    C = k/T1;        % u equation coefficients

    for j = 1:loopPlant
        [X,Y] = plant(X, U, Tp, A, B, C); % simulation
        outX1 =  [outX1, X(1)]; % data collection
        outX2 =  [outX2, X(2)]; % data collection
        outY = [outY, Y]; % data collection
    end
        
    outYhorizon = [outYhorizon, outY(end)];% data collection
    outU = [outU, U]; % data collection
    outE = [outE, SP - outY(end)]; % data collection
    outSP = [outSP, SP]; % data collection
    
    %% PARAM CHANGE 
    
    SP = SP + SPChange(1,i,60);   
    
    %% CONTROL AND IDENTIFICATION
    
    %[U, Ui] = PIDcontroller(outE(end),outE(end),Ui,20.55,6.15,5);
    %U = 1; % step
    %U = noise(i); % white noise
    U = 10 * sin(0.1* i) + 5* sin(5*i) +SP ; % double sine
    %U = 0.25 * sin(5 * i) + 0.5* sin(0.5*i) - 0.75* sin(1.5*i); % triple sine

    %if i < 40
     %   U = 10 * sin(4 * i) + 4* sin(12*i); % double sine
        %U = noise(i); % white noise
    %else
     %   [R,S,T] = PolePlacement(transDiscParam(3:4), transDiscParam(1:2), alfa);
        %[R,S,T] = PolePlacement(RLSb(3:4), RLSb(1:2), alfa);
       % U = PolePlacementController(R,S,T,outYhorizon,SP,outU);
    %end
    
    if i > 3 % safety mechanism for acquiring samples
        %fi = [-RLSY(end-2), - RLSY(end-3), outU(end-2), outU(end-3)]'; %prediction based on the model output instead of the plant
        fi = [-outYhorizon(end-1), -outYhorizon(end-2), outU(end), outU(end-1)]';
        [RLSb,RLSP] = rls(fi,outYhorizon(end),RLSP,RLSb,RLSalfa); % RLS algorithm
        RLSParam(:,i) = RLSb;
        RLSY = [RLSY, plantModel(fi,RLSb)]; % predicted output
    end
    
end

%% VALIDATION
%{
%step responses should be identical
z = tf('z',Ts);
B_z = transDiscParam(3) + transDiscParam(4) * z^(-1);
A_z = 1 + transDiscParam(1) * z^(-1) + transDiscParam(2) * z^(-2);
R_z = R(1) + R(2) * z^(-1);
S_z = S(1) + S(2) * z^(-1);
K_loop = z^(-1) * (T * (B_z / (R_z * A_z))) / (1 + z^(-1) * B_z * S_z / (R_z * A_z));

Am_z = 1 + alfa * z^(-1);
K_predict = z^(-1) * T * B_z / Am_z;
step(K_loop); hold on; step(K_predict);
%}

%% plot results
figure; hold on; leg = [];
yyaxis right;
stairs(0:1:loopControl, outU, 'g-'); leg = [leg; 'CV-'];
yyaxis left
plot(time,outY, 'r-'); leg = [leg; 'PV-'];
%stairs(0:1:loopControl, outSP, 'c-'); leg = [leg; 'SP-'];
stairs(0:1:loopControl, RLSY, 'b-'); leg = [leg; 'RLS'];
grid on
legend(leg);

%% plot RLS
figure; hold on; RLSleg = [];
plot(RLSParam(1,:), 'g-'); RLSleg = [RLSleg;'a1'];
plot(RLSParam(2,:), 'r-'); RLSleg = [RLSleg;'a2'];
plot(RLSParam(3,:), 'c-'); RLSleg = [RLSleg;'b0'];
plot(RLSParam(4,:), 'b-'); RLSleg = [RLSleg;'b1'];
line([0, loopControl], [transDiscParam(1), transDiscParam(1)], 'Color', 'g', 'LineStyle', '--');
line([0, loopControl], [transDiscParam(2), transDiscParam(2)], 'Color', 'r', 'LineStyle', '--');
line([0, loopControl], [transDiscParam(3), transDiscParam(3)], 'Color', 'c', 'LineStyle', '--');
line([0, loopControl], [transDiscParam(4), transDiscParam(4)], 'Color', 'b', 'LineStyle', '--');
grid on
legend(RLSleg);

%% print

%transDiscParam
RLSb