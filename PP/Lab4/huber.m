function y = huber(x, k)

    s = 1 / 0.675 * median(abs(x));
%     
%    figure;
%    plot(x, '*');
    
    x(x > k*s) = k*s;
    x(x < -k*s) = -k*s;
    
    y = x;
    
    
%    hold on;
%    plot(y, '*');
end