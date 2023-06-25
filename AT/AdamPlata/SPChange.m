function deltaSP = SPChange(delta, i, iSP) % change SP every given iteration
deltaSP = 0;
if mod(i,iSP) == 0
    deltaSP = delta;
end
if mod(i,2*iSP) == 0
    deltaSP = -delta;
end
end