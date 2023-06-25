function [mic_data] = simulate_microphone(mic_data, noise, cancel, noise_B, cancel_B, n)

    noise_nB  = length(noise_B);
    cancel_nB = length(cancel_B);
    
    mic_data_new = zeros(n, 1);
    
    for i = 1:n
        k = i - 1;
        mic_data_new(n - k) = flip(noise_B)  * noise ((end - k - noise_nB + 1) :(end - k)) ...
                            + flip(cancel_B) * cancel((end - k - cancel_nB + 1):(end - k));
    end
    
    mic_data = [mic_data; mic_data_new];
end

