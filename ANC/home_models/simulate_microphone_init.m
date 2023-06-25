function [mic_data] = simulate_microphone_init(noise_B, cancel_B, N_iterations)

    nB = max([length(noise_B), length(cancel_B)]);

    mic_data = zeros(nB + N_iterations * 4, 1);

end

