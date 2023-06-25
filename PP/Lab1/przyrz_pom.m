function [wy] = przyrz_pom(x, b, xw, yw, sig)
%wy=przyrzad_lin(x,b,xw,yw,sig) % x - wejście % wy - wynik pomiaru % b - współczynynniki modelu, b=[b0, b1] % xw, yw - dane z wzrocowania; % sig - sigma zaklocen

    bd = polyfit(xw,yw,1); %wzorcowanie

    c0 = -bd(2)/bd(1); c1=1/bd(1);

    wy = c0+c1 * (b(1)+b(2) * x + randn(size(x)) * sig);
end

