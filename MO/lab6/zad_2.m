clear;
close all;
clc;

a = [   0;
        8;
        2;
        4*ones(9,1);
        4*ones(9,1);
    ];

v = a;

eps = 0.2;

x0 = 10;

R1 = @(u) 0.5 * (x0 - sum(u) - v(1)).^2; %xn

R2 = @(u) (x0 - sum(u(1:5)) - v(2)).^2; %x5

R3 = @(u) (u(3) - v(3)).^2; % u2

% Nierownosciowe

R4 = @(u) 0.5 * sum((u - v(4:12)) .* max(0, u - v(4:12)));

R5 = @(u) 0.5 * sum((-u - v(13:21)) .* max(0, -u - v(13:21)));

t = 1000;

fun = @(u) J(u) + t * (R1(u) + R2(u) + R3(u) + R4(u) + R5(u)); 

alfa = 2;
beta = 2;

c = 0.3;

u{1} = 4 * ones(9, 1);

for i = 2:100
    u{i} = fminsearch(fun, u{i-1});
    disp(u{i}(:));
    u = u{i}(:);
    x = zeros(1, 10);
    x(1) = x0;
    for j = 1:9
        x(j+1) = x(j) - u(j);
    end
    disp(x);
    a{i} = [x(10);
            x(6);
            u(3);
            u
            u];
    a{i} = a{i} - a;
    
    
end