function [wy, x_cenzura] = dixon(x, minmax)
    x = sort(x);
    x = x(:)';
    n = length(x);

    crit_dixon = [  0.941;
                    0.765;
                    0.642;
                    0.560;
                    0.507;
                    0.554;
                    0.512;
                    0.477;
                    0.576;
                    0.516;
                    0.521;
                    0.546;
                    0.525;
                    0.507;
                    0.490;
                    0.475;
                    0.462;
                    0.450;
                    0.440;
                    0.430;
                    0.421;
                    0.413;
                    0.406
                 ];
    
    rsmall = @(x, i, j) ( (x(1 + i) - x(1)) ./ (x(end-j) - x(1)) );
    rlarg  = @(x, i, j) ( (x(end) - x(end - i)) ./ (x(end) - x(1 + j)) );
    
    if (n <= 7)
        i = 1;
        j = 0;
    elseif (n <= 10)
        i = 1;
        j = 1;
    elseif (n <= 13)
        i = 2;
        j = 1;
    elseif (n <= 25)
        i = 2;
        j = 2;
    end
    x_cenzura = [];
    if (minmax == 'min')
        if (rsmall(x, i, j) >= crit_dixon(n - 2))
            wy = 'Dana nalezy odrzucic z proby';
            x_cenzura = min(x);
        else
            wy = 'W danych nie wykryto bledow grubych'; 
        end
    end
    if (minmax == 'max')
        if (rlarg(x, i, j) >= crit_dixon(n - 2))
            wy = 'Dana nalezy odrzucic z proby';
            x_cenzura = max(x);
        else
            wy = 'W danych nie wykryto bledow grubych'; 
        end
    end
end