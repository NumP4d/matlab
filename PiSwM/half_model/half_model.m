function [vri_n, xri_n, wi_n, fii_n] = half_model(Params, vri, xri, wi, fii, xnr1i, Ft1, xnr2i, Ft2, xr1i, xr2i)
    Ts  = Params(1);
    mr  = Params(2);
    Jr  = Params(3);
    kr1 = Params(4);
    l1  = Params(5);
    kr2 = Params(6);
    l2  = Params(7);
    g   = Params(8);
    
    Fk1 = kr1 * (xr1i - xnr1i);
    Fk2 = kr2 * (xr2i - xnr2i);
    
    % vr, xr equations
    vri_n = - Fk1 - Ft1 - Fk2 - Ft2 + mr * g;
    vri_n = vri_n * Ts / mr + vri;
    xri_n = vri * Ts + xri;

    % w, fi equations
    %wi_n  = Ft2 * l2 - Ft1 * l1 + Fk2 * l2 - Fk1 * l1;
    wi_n  = (Ft2 + Fk2) * l2 - (Ft1 + Fk1) * l1;
    wi_n  = wi_n * Ts / Jr + wi;
    fii_n = wi * Ts + fii;
end