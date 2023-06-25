filename_prefix = './paths/paths_diag080/node';

Fs = 2000;

Walls   = 0:4;
Act     = 0:4;  % 4 is only for 4 wall (Top)
Speaker = 7;
Mics    = [3, 11, 19, 27, 35];

B_act = {};
close all;

figure;
hold on;
grid on;
xlim([0, Fs/2]);

for k = 1:length(Mics)
    p_wzbd = 1;
    for i = 1:length(Walls)
        for j = 1:length(Act)
            % Do not take actuator 4 from other walls than top
            if ((Act(j) == 4) && (Walls(i) ~= 4))
                continue;
            end
            B_act{k, p_wzbd} = csvread([filename_prefix, num2str(Walls(i)), '_', num2str(Act(j)), '_', num2str(Mics(k)), '.csv']);
            B_act{k, p_wzbd} = B_act{k, p_wzbd}(:, 1)';
            [H{k, p_wzbd}, W] = freqz(B_act{k, p_wzbd}, 1, 1024);
            H{k, p_wzbd} = 10 * log10(abs(H{k, p_wzbd}));
            F = W / pi * Fs / 2;
            plot(F, H{k, p_wzbd});
            p_wzbd = p_wzbd + 1;
        end
    end
end

% Load speaker to mics path
B_speaker = {};

for i = 1:length(Mics)
    B_speaker{i} = csvread([filename_prefix, '0_7_', num2str(Mics(i)), '.csv']);
    B_speaker{i} = B_speaker{i}(:, 1)';
    [H_speaker{i}, W] = freqz(B_speaker{i}, 1, 1024);
    H_speaker{i} = 10 * log10(abs(H_speaker{i}));
    plot(F, H{i});
end

% Load speaker to reference microphone path

B_ref = csvread([filename_prefix, '0_0_0.csv']);
B_ref = B_ref(:, 1)';

[H_ref, W] = freqz(B_ref, 1, 1024);
H_ref = 10 * log10(abs(H_ref));
plot(F, H_ref);