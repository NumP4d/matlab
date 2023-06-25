function [ c ] = ANC_U_con( coefs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    x_ = dec2bin(0:2^5-1)-'0';
    %x_ = dec2bin(0:2^15-1)-'0';
    %e = x_(1:8);
    %u = x_(9:15);
    e = x_(1:3);
    u = x_(4:5);
    e(e == 1) = 1000;
    e(e == 0) = -1000;
    u(u == 1) = 2047;
    u(u == 0) = -2047;
    x_ = [e, u];
    
    k = [coefs(1:3), coefs(5:6)];
    %k = [coefs(1:8) / coefs(9), coefs(10:16) / coefs(9)];
    
    c = 0;  % return true at first
    
    u_min = -2047;
    u_max = 2047;
    
    for i = 1:size(x_, 1)
        u = sum(k .* x_(1, :));
        if (u > u_max || u < u_min) % if saturation is reached return no condiction ok (c(x) <= 0 is ok, 1 is not ok)
            c = 1;
            return;
        end
    end

end

