close all

fs = 500;
ts = 10;
N = fs*500;


s = tf('s');
% K = 1/(1+s);

m = 100;
k = 20000;
c = 500;
K = (k + c*s)/(m*s^2 + c*s + k);

xi = sinus;
yi = lsim(K,xi,ti);

figure; plot(ti, yi)

T_sim = [];

for n = 0:50-1
    yn = yi(n*5000 + 2500 +1:(n+1)*5000);
    xn = xi(n*5000 + 2500 +1:(n+1)*5000);
    
    T_sim = [T_sim; rms(yn)/rms(xn)];
end

figure; plot(0.5:0.5:25, T_sim)


xi = czirp;
yi = lsim(K,xi,ti);
figure; plot(ti, yi)

[T_czirp, f_czirp] = pwelch(yi,6000,[],[],fs);
[T_wym, f_wym] = pwelch(xi,6000,[],[],fs);
figure; plot(f_czirp,sqrt(T_czirp./T_wym))