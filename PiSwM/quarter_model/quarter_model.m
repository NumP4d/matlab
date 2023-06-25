function [vri_n, xri_n] = quarter_model(Params, vri, xri, xnri, Ft)
    Ts  = Params(1);
    mr  = Params(2);
    kr  = Params(3);
    g   = Params(4);
    
    vri_n = - kr * (xri - xnri) - Ft + mr * g;
    vri_n = vri_n * Ts / mr + vri;
    xri_n = vri * Ts + xri;
end