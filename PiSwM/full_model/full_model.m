function [vri_n, xri_n, wi_n, fii_n] = full_model(Params, vri, xri, wi, fii, xnri, Ft, xrti)
    Ts   = Params(1);
    mr   = Params(2);
    Jp   = Params(3);
    Jr   = Params(4);
    kr11 = Params(5);
    l1p  = Params(6);
    kr21 = Params(7);
    l2p  = Params(8);
    kr12 = Params(9);
    l1r  = Params(10);
    kr22 = Params(11);
    l2r  = Params(12);
    g    = Params(13);
    
    kr = [kr11, kr12;
          kr21, kr22];
      
    J  = [Jp;
          Jr];
    
    Fk = kr .* (xrti - xnri);
    
    % vr, xr equations
    vri_n = -sum(sum(Fk)) - sum(sum(Ft)) + mr * g;
    vri_n = vri_n * Ts / mr + vri;
    xri_n = vri * Ts + xri;

    % w, fi equations
    wi_n  = zeros(size(wi));
    
    wi_n(1)  = (Ft(2, 1) + Ft(2, 2) + Fk(2, 1) + Fk(2, 2)) * l2p - (Ft(1, 1) + Ft(1, 2) + Fk(1, 1) + Fk(1, 2)) * l1p;
    
    wi_n(2)  = (Ft(1, 1) + Ft(2, 1) + Fk(1, 1) + Fk(2, 1)) * l1r - (Ft(1, 2) + Ft(2, 2) + Fk(1, 2) + Fk(2, 2)) * l2r;
    
    wi_n  = wi_n .* Ts ./ J + wi;
    fii_n = wi * Ts + fii;
end