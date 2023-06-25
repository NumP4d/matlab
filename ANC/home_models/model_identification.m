function [B, A, H_w, mag, phase_shift] = model_identification(output_signal, excitation_signal, nB, nA)

    n = length(output_signal);
    w = 0:pi/(n):pi;
    w = w(1:(end-1));

    % Calculate 
    H_w = fft(output_signal) ./ fft(excitation_signal);
    % Must be zero at 0 Hz frequency
    H_w(1) = 0;
    
    % Identifcation of discrete filter model parameters
    [B, A] = invfreqz(H_w, w, nB, nA);
    
    % Return only first half of samples to Nyquist frequency
    H_w = H_w(1:end/2);

    % Magnitude in dB
    mag = 10*log(abs(H_w));
    
    % Angle in degrees
    phase_shift = angle(H_w) * 180 / pi;
end

