close all;

fs = 500;
N = 250000;

T = (0:N-1)/fs;

ti = [];
xi = [];

i = 0;
for F = 0.5:0.5:25
    dt = 1/fs;
    sp = 10; 
    
    t = (0+(sp*i):dt:sp+(sp*i)-dt)';
    
    A = 0.05 * (2./F);
    x = A*sin(2*pi*F*t);
    
    ti = [ti; t];
    xi = [xi; x];
    
    i = i + 1;
end

% figure; plot(ti,xi)

sinus = xi;
Ai = linspace(0.2,0.004,250000)'; 
czirp = Ai.*chirp(ti,0.5,ti(end),25);
figure; plot(ti,czirp)

