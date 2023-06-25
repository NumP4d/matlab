clear;
close all;
clc;

filename = 'COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv';

filename2 = 'COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv';

filename3 = 'COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv';

Country = 184;
%Country = 50:82;

X = csvread(filename, 1, 4);
Y = csvread(filename2, 1, 4);
Z = csvread(filename3, 1, 4);

X = X(:, 1:end-1);
Y = Y(:, 1:end-1);
Z = Z(:, 1:end-1);

cases_Country = X(184, :);

deaths_Country = cases_Country;

t = datetime(2020, 1, 22);
% Time creation
for i = 2:length(cases_Country)
    new_date = t(end) + caldays(1);
    t = [t, new_date];
end

for i = 1:length(cases_Country)
%     cases_Country(i) = sum(X(50:82, i)) - sum(Y(50:82, i)) - sum(Z(50:82, i));
%     deaths_Country(i) = sum(Z(50:82, i));
     %cases_Country(i) = sum(X(:, i));% - sum(Y(:, i)) - sum(Z(:, i));
     %deaths_Country(i) = sum(Z(:, i));
     %cases_Country(i) = sum(X(Country, i)) - sum(Y(Country, i)) - sum(Z(Country, i));
     %deaths_Country(i) = sum(Z(Country, i));
     cases_Country(i) = sum(X(205, i)) - sum(Y(192, i)) - sum(Z(205, i));
     deaths_Country(i) = sum(Z(205, i));
     %cases_Country(i) = sum(X(29, i)) - sum(Y(30, i)) - sum(Z(29, i));
     %deaths_Country(i) = sum(Z(29, i));
end

diffs = diff(cases_Country);

figure;
plot(t, cases_Country, 'b.');
hold on;
grid on;
plot(t, cases_Country, 'b');
plot(t, deaths_Country, 'r.');
plot(t, deaths_Country, 'r');
xlim([t(1), t(end)]);
xlabel('time');
ylabel('COVID-19 confirmed cases');

figure;
plot(t(2:end), diffs, 'b');
hold on;
grid on;
%plot(t(2:end), diffs, 'b');
xlim([t(2), t(end)]);
xlabel('time');
ylabel('COVID-19 daily confirmed cases');

Country = 29;
percent_deaths = sum(Z(Country, i)) ./ sum(X(Country, i)) * 100
percent_recovered = sum(Y(30, i)) ./ sum(X(Country, i)) * 100