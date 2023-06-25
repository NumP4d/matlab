function [ Ho_w ] = ANC_Ho_w( c )

    H = load('H_w.mat');

    w = 2*pi*(1:length(H.H_w))';
    
    %Hr = @(z) c;
    
    %Hr = @(z) (c(1) + c(2) * z.^(-1) + c(3) * z.^(-2) + c(4) * z.^(-3) + c(5) * z.^(-5) + c(6) * z.^(-6) + c(7) * z.^(-7) + c(8) * z.^(-8)) ./ ...
    %           (c(9) + c(10) * z.^(-1) + c(11) * z.^(-2) + c(12) * z.^(-3) + c(13) * z.^(-5) + c(14) * z.^(-6) + c(15) * z.^(-7) + c(16) * z.^(-8));
    
    fc = 60;
    fs = 16000;
    [b, a] = butter(1, fc/fs, 'high');
    
    H_highpass = @(z) (b(1) + b(2) * z.^(-1)) ./ (a(1) + a(2) * z.^(-1));
    
    % Hr_w = Hr(exp(1i * 2 * pi * f(1:(n/2))));
    % 
    % Ho_w = H_w(1:n/2) .* Hr_w;

    % Hr = @(z) (c(1) + c(2) * z.^(-1) + c(3) * z.^(-2)) ./ (c(4) + c(5) * z.^(-1) + c(6) * z.^(-2));
    Hr = @(z) (c(1) + c(2) * z.^(-1) + c(3) * z.^(-2)) ./ (1.0 + c(5) * z.^(-1) + c(6) * z.^(-2));

    %Ho_w = H.H_w .* Hr(1i * w);
    
    T = 1 / fs;
    
    Tustin = (1 + 1i * w * T / 2) ./ ( 1 - 1i * w * T/2);
    
    Ho_w = H.H_w .* H_highpass(Tustin) .* Hr(Tustin);

end

