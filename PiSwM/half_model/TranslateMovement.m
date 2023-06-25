function [vr1, xr1, vr2, xr2] = TranslateMovement(Params, vr, xr, w, fi)
    l1 = Params(1);
    l2 = Params(2);
    
    xr1 = xr + l1 * fi;
    vr1 = vr + l1 * w;
    xr2 = xr - l2 * fi;
    vr2 = vr - l2 * w;
        
    %xr1 = xr + l1 * sin(fi);
    %vr1 = xr + l1 * cos(fi) * w;
    %xr2 = vr - l2 * sin(fi);
    %vr2 = vr - l2 * cos(fi) * w;
end