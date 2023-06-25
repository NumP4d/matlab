function [out_interpolated] = interpolate(out_interpolated, out_data, n)

    B_FIR = n * ...
            [-0.0003, -0.0010, -0.0020, -0.0037, ...
             -0.0056, -0.0070, -0.0067, -0.0033, ...
              0.0045,  0.0174,  0.0351,  0.0563, ...
              0.0787,  0.0994,  0.1152,  0.1239, ...
              0.1239,  0.1152,  0.0994,  0.0787, ...
              0.0563,  0.0351,  0.0174,  0.0045, ...
             -0.0033, -0.0067  -0.0070, -0.0056, ...
             -0.0037, -0.0020, -0.0010, -0.0003];
    
    nFIR = length(B_FIR);
       
    out_data_horizon = zeros(nFIR + n, 1);
    
    k = 0;
    for i = (nFIR + n):-1:1
        if (mod(i, n) == 0)
            out_data_horizon(i) = out_data(end - k);
            k = k + 1;
        else
            out_data_horizon(i) = 0;
        end
    end
    
    out_interpolated_new = zeros(n, 1);
    
    for i = 1:n
        out_interpolated_new(i) = flip(B_FIR) * out_data_horizon((i + 1):(end - n + i));
    end 
    
    out_interpolated = [out_interpolated; out_interpolated_new];
end

