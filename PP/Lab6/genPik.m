function [y] =  genPik(h, w, p, x)

    y=[];
    for i=1:length(x)
       y(i) = h * exp( (-log(256) * (x(i)-p)^2) / (2*w*w) ); 
    end

end