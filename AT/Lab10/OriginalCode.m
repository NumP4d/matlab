clear all;
close all;
clc;

% Loading the Signal of Interest
load handel;
v = y'/2; plot((1:length(v))/Fs,v); xlabel('Time [sec]'); ylabel('Amplitude');
title('Signal of Interest, v(n)');

% Listening to the Sound Clip
p8 = audioplayer(v,Fs);
playblocking(p8);

% Generating the Noise Signal
eta = 0.5*sin(2*pi/Fs*1000*(1:length(v)));

figure;
plot(1/Fs:1/Fs:0.01,eta(1:floor(0.01*Fs)));
xlabel('Time [sec]');
ylabel('Amplitude');
title('Noise Signal, eta(n)');

% Listening to the Noise
p8 = audioplayer(eta(1:Fs),Fs);
playblocking(p8);

% Measured Signal
s = v + eta;

figure;
plot((1:length(s))/Fs,s);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Measured Signal');
p8 = audioplayer(s(1:2.5*Fs),Fs);
playblocking(p8);

% Adaptive Filter Configuration
D = 100;
L = 32;

N = 32;
ntr = N*floor((length(v)-D)/N);
x = s(1:ntr);
d = s(1+D:ntr+D);

% Block LMS
mu = 0.0001;
leak = 1; % No leakage
h = adaptfilt.blms(L,mu,leak,N);

% Refining the Step Size
[mumax,mumaxmse] = maxstep(h,x)

% Running the Filter
[y,e] = filter(h,x,d);
figure;
plot(1/Fs:1/Fs:ntr/Fs,v(1+D:ntr+D),...
1/Fs:1/Fs:ntr/Fs,e,1/Fs:1/Fs:ntr/Fs,e-v(1+D:ntr+D));
xlabel('Time [sec]');
ylabel('Signals');
legend('Noiseless Music Signal v(n)',...
'Error Signal e(n)','Difference e(n)-v(n)');

% Listening to the Error Signal
p8 = audioplayer(e,Fs);
playblocking(p8);

% Listening to the Residual Signal
p8 = audioplayer(e-v(1+D:ntr+D),Fs);
playblocking(p8);

% FM Noise Source
eta = 0.5*sin(2*pi*1000/Fs*(1:length(s))+...
10*sin(2*pi/Fs*(1:length(s))));
s = v + eta;
plot((1:length(s))/Fs,s);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Measured Signal');

% Listening to the Music + Noise Signal
p8 = audioplayer(s(1:4.5*Fs),Fs);
playblocking(p8);

mu = 0.005;
x = s(1:ntr);
d = s(1+D:ntr+D);
h = adaptfilt.blms(L,mu,leak,N);

% Running the Adaptive Filter
[y,e] = filter(h,x,d);
plot(1/Fs:1/Fs:ntr/Fs,v(1+D:ntr+D),...
1/Fs:1/Fs:ntr/Fs,e,1/Fs:1/Fs:ntr/Fs,e-v(1+D:ntr+D));
xlabel('Time [sec]');
ylabel('Amplitude');
title('Signals');
legend('Noiseless Music Signal v(n)',...
'Error Signal e(n)','Difference e(n)-v(n)');

% Listening to the Error Signal
p8 = audioplayer(e,Fs);
playblocking(p8);