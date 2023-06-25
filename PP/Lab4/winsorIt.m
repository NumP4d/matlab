function y = winsorIt(x, m)
    [~, I] = sort(x);
    xmin = x(I(1 + m));
    xmax = x(I(end - m));
    
    x(x < xmin) = xmin;
    x(x > xmax) = xmax;
    
    y = x;  
end