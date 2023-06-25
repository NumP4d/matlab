function [vrt, xrt] = TranslateMovement(Params, vr, xr, w, fi)
    l1p = Params(1);
    l2p = Params(2);
    l1r = Params(3);
    l2r = Params(4);
    
    wp  = w(1);
    wr  = w(2);
    fip = fi(1);
    fir = fi(2);
    
    xrt = zeros(2, 2);
    vrt = zeros(2, 2);
    
    xrt(1, 1) = xr + l1p * fip - l1r * fir;
    vrt(1, 1) = vr + l1p * wp  - l1r * wr;
    xrt(2, 1) = xr - l2p * fip - l1r * fir;
    vrt(2, 1) = vr - l2p * wp  - l1r * wr;
    
    xrt(1, 2) = xr + l1p * fip + l1r * fir;
    vrt(1, 2) = vr + l1p * wp  + l1r * wr;
    xrt(2, 2) = xr - l2p * fip + l2r * fir;
    vrt(2, 2) = vr - l2p * wp  + l2r * wr;
end