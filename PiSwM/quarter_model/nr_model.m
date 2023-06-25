function [vnri_n, xnri_n] = nr_model(Params, vnri, xnri, xri, x0i, Ft)
    Ts  = Params(1);
    mnr = Params(2);
    kr  = Params(3);
    knr = Params(4);
    g   = Params(5);
    
    vnri_n = kr * (xri - xnri) + Ft - knr * (xnri - x0i) + mnr * g;
    vnri_n = vnri_n * Ts / mnr + vnri;
    xnri_n = vnri * Ts + xnri;
end