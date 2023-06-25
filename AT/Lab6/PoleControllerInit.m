function [R, T, S] = PoleControllerInit(k, T1, T2, Tc, alfa, beta)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Calculate final transfer function parameters
    s = tf('s');
    Ks = k / (1 + T1*s) / (1 + T2*s);
    Kd = c2d(Ks, Tc);
    figure;
    pzmap(Kd);
    Kf = filt(Kd.Numerator, Kd.Denominator);
    b = cell2mat(Kf.Numerator);
    a = cell2mat(Kf.Denominator);
    bi = [b(2:end), a(2:end)]';
    % Take from RLS last stable parameters
%     bi = [  0.0069;
%             0.0070;
%            -1.8530;
%             0.8576];

    b = [0, bi(1), bi(2)];
    a = [1, bi(3), bi(4)];
    
    % Discrete Plant gain:
    %plant_gain = sum(b) / sum(a);
    %Km = 1 / plant_gain;
    Km = (1 + alfa) / (1 + beta)
    
    a0 = a(1)
    a1 = a(2)
    a2 = a(3)
    
    b0 = b(2)
    b1 = b(3)
    
    f0 = 1;
    g0 = (-a2 - a1 * alfa + a1^2 + b0 * a2 * alfa / b1 - b0 * a2 * a1 / b1) / (-a1 * b0 + b0^2 * a2 / b1 + b1);
    f1 = alfa - a1 - b0 * g0;
    g1 = - a2 * f1 / b1;
    
    z = tf('z', Tc);
    K_l = 1 + alfa * z^(-1)
    K_p = (1 + a1 * z^(-1) + a2 * z^(-2)) * (f0 + f1 * z^(-1)) + z^(-1) * (b0 + b1 * z^(-1)) * (g0 + g1 * z^(-1))
    
    disp(f0);
    disp(a1 * f0 + f1 + b0 * g0);
    disp(a2 * f0 + a1 * f1 + b0 * g1 + b1 * g0);
    disp(a2 * f1 + b1 * g1);
    
    %R = [f0, f1];
    R = [f0*b0, (f1*b0 + f0*b1), f1*b1];
    T = Km * [1, beta];
    S = [g0, g1];
    
    B_z = b0 + b1 * z^(-1);
    A_z = a0 + a1 * z^(-1) + a2 * z^(-2);
    %R_z = f0 + f1 * z^(-1);
    R_z = R(1) + R(2) * z^(-1) + R(3) * z^(-2);
    T_z = T(1) + T(2) * z^(-1);
    S_z = g0 + g1 * z^(-1);
    K_petli = z^(-1) * (T_z * (B_z / (R_z * A_z))) / (1 + z^(-1) * B_z * S_z / (R_z * A_z))
    
    K_mianownik = (f0 + f1 * z^(-1)) * A_z + z^(-1) * S_z
    
    figure;
    pzmap(K_petli);
    
    K_plant = z^(-1) * (B_z) / (A_z)
    
%     figure;
%     step(K_plant)
    
    figure;
    step(K_petli);
    
    Am_z = 1 + alfa * z^(-1);
    K_expect = z^(-1) * Km * (1 + beta * z^(-1)) / Am_z
    
    hold on;
    grid on;
    step(K_expect);
    legend('system loop', 'expected');
end

