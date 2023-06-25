function [ out ] = wsk_jak( u )
x = zeros(1,6);
x(1) = 17;
for i=1:1:5
    x(i+1) = 0.9*x(i) + u(i);
end
xN = x(6);
x = x(1:5);
%max(x-12,0);

%out = sum(u.^2 + (x-20).^2)/2 + 0.1*(sum((x-21).*max([x-21, zeros(length(x),1)], [], 2)) + 0.5*(xN-20)^2 + sum((-u).*max([-u, zeros(length(u),1)], [], 2))+sum((-x).*max([-x, zeros(length(x),1)], [], 2)));
out = sum(u.^2 + (x-20).^2)/2 + 0.1*(sum((x-21).*max(x-21, 0)) + 0.5*(xN-20)^2 + sum((-u).*max(-u, 0))+sum((-x).*max(-x, 0)));

end
