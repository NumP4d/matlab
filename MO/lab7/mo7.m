clc
clear all 
close all

x(1) = 200
p(1) = 0;
N = 16;

a=-1000000;
b=1000000;

epsilon = 0.0001;

while(1)
    % a
    p(1)= a;  
    for i = 1:N
        x(i+1) = (4/3)*x(i) - (1/6)*p(i);
        p(i+1) = p(i) - 2*x(i);
        u(i) = (1/3)*x(i) - (1/6)*p(i);
    end
    pnA = p(N);
    
    if (abs(p(N)) < epsilon)
        break
    end
    
% b
    p(1)= b;  
    for i = 1:N
        x(i+1) = (4/3)*x(i) - (1/6)*p(i);
        p(i+1) = p(i) - 2*x(i);
        u(i) = (1/3)*x(i) - (1/6)*p(i);
    end
    pnB = p(N);
    p(N)
    if (abs(p(N)) < epsilon)
        break
    end
    
 % x
    p(1)= (a+b)/2;  
    for i = 1:N
        x(i+1) = (4/3)*x(i) - (1/6)*p(i);
        p(i+1) = p(i) - 2*x(i);
        u(i) = (1/3)*x(i) - (1/6)*p(i);
    end
    pnX =p(N);
    
    if (abs(p(N)) < epsilon)
        break
    end
    
    if pnA * pnX < 0
        b = (a+b)/2;
    else
        a = (a+b)/2;
    end
    
end

p(N)

    for i = 1:N
        J(i) = x(i)*x(i) + 3*u(i)*u(i);
    end
    J = sum(J)
    
