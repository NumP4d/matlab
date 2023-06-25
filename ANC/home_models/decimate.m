function [mic_decimated, decim_data] = decimate(mic_decimated, decim_data, mic_data, n)

    B_iir = [0.9883, -2.9635, 2.9635, -0.9883];

    A_iir = [1.0000, -2.9751, 2.9518, -0.9767];
    
    nIIR  = length(B_iir);

    B_FIR = [-0.0003, -0.0010, -0.0020, -0.0037, ...
             -0.0056, -0.0070, -0.0067, -0.0033, ...
              0.0045,  0.0174,  0.0351,  0.0563, ...
              0.0787,  0.0994,  0.1152,  0.1239, ...
              0.1239,  0.1152,  0.0994,  0.0787, ...
              0.0563,  0.0351,  0.0174,  0.0045, ...
             -0.0033, -0.0067  -0.0070, -0.0056, ...
             -0.0037, -0.0020, -0.0010, -0.0003];
    
    nFIR = length(B_FIR);
         
    decim_data = [decim_data; zeros(n, 1)];
         
    for i = (n-1):-1:0
        decim_data(end - i) = flip(B_iir) * mic_data((end - i - nIIR + 1):(end - i)) ...
                            - flip(A_iir(2:end)) * decim_data((end -i - nIIR + 1):(end - i - 1));
    end
    
    mic_decimated_new = flip(B_FIR) * decim_data(end - nFIR + 1:end);
    
    mic_decimated = [mic_decimated; mic_decimated_new];
         
end

