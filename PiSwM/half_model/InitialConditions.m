function [xr0, fi0, xnr10, xnr20] = InitialConditions(Params)
    mr   = Params(1);
    mnr1 = Params(2);
    kr1  = Params(3);
    knr1 = Params(4);
    l1   = Params(5);
    mnr2 = Params(6);
    kr2  = Params(7);
    knr2 = Params(8);
    l2   = Params(9);
    g    = Params(10);

    % Solve system equations A * X = B where X = [xnr10; xnr20; xr0; fi0]
    % Equations are obtainead for steady-state model (all differentials are 0)
    
    % Prepare equation matrices:
    A = [   -(kr1 + knr1), 0, kr1, kr1*l1;
            0, -(kr2 + knr2), kr2, -kr2*l2;
            kr1, kr2, -(kr1 + kr2), (-kr1*l1 + kr2*l2);
            kr1*l1, -kr2*l2, (-kr1+l1 + kr2*l2), (-kr1*l1^2 - kr2*l2^2)
        ];
    
    B = [   -mnr1*g;
            -mnr2*g;
            -mr*g;
            0
        ];
    
    % Solve equation system
    X = linsolve(A, B);
    
    % Obtain results
    xnr10 = X(1);
    xnr20 = X(2);
    xr0   = X(3);
    fi0   = X(4);
end