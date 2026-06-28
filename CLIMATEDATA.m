clc;
clear;
close all;

%% 🔹 STEP 1: Load Data
data = readtable('DailyDelhiClimateTrain.csv'); % <-- put your file name

%% 🔹 STEP 2: Convert Date
data.DATE = datetime(data.DATE);

%% 🔹 STEP 3: Remove Missing Values
data = rmmissing(data);

%% 🔹 STEP 4: Basic Temperature Plot
figure;
plot(data.DATE, data.temp);
xlabel('Date');
ylabel('Temperature (°C)');
title('Daily Temperature');
grid on;

%% 🔹 STEP 5: Extract Year & Month
data.Year = year(data.DATE);
data.Month = month(data.DATE);

%% 🔹 STEP 6: Yearly Average Temperature
yearly_avg = groupsummary(data, 'Year', 'mean', 'temp');

figure;
plot(yearly_avg.Year, yearly_avg.mean_temp, 'LineWidth', 2);
xlabel('Year');
ylabel('Avg Temperature (°C)');
title('Yearly Temperature Trend');
grid on;

%% 🔹 STEP 7: Monthly Average Temperature
monthly_avg = groupsummary(data, 'Month', 'mean', 'temp');

figure;
bar(monthly_avg.Month, monthly_avg.mean_temp);
xlabel('Month');
ylabel('Avg Temperature (°C)');
title('Monthly Temperature');
grid on;

%% 🔹 STEP 8: Moving Average
smoothed = movmean(data.temp, 30);

figure;
plot(data.DATE, data.temp);
hold on;
plot(data.DATE, smoothed, 'r', 'LineWidth', 2);
legend('Original', 'Smoothed');
title('Temperature Smoothing');
grid on;

%% 🔹 STEP 9: Trend Line
x = datenum(data.DATE);
p = polyfit(x, data.temp, 1);
trend = polyval(p, x);

figure;
plot(data.DATE, data.temp);
hold on;
plot(data.DATE, trend, 'k', 'LineWidth', 2);
legend('Data', 'Trend');
title('Temperature Trend Line');
grid on;

%% 🔹 STEP 10: Anomalies
meanTemp = mean(data.temp);
anomaly = data.temp - meanTemp;

figure;
plot(data.DATE, anomaly);
xlabel('Date');
ylabel('Anomaly');
title('Temperature Anomaly');
grid on;

%% 🔹 STEP 11: Heatmap (Year vs Month)
[uniqueYears, ~, yIdx] = unique(data.Year);
[uniqueMonths, ~, mIdx] = unique(data.Month);

tempMatrix = accumarray([yIdx, mIdx], data.temp, [], @mean);

figure;
imagesc(uniqueMonths, uniqueYears, tempMatrix);
colorbar;
xlabel('Month');
ylabel('Year');
title('Temperature Heatmap');

%% 🔹 STEP 12: Temperature vs Humidity
figure;
scatter(data.temp, data.humidity);
xlabel('Temperature');
ylabel('Humidity');
title('Temp vs Humidity');
grid on;

%% 🔹 STEP 13: Max vs Min Temperature
figure;
plot(data.DATE, data.tempmax, 'r');
hold on;
plot(data.DATE, data.tempmin, 'b');
legend('Max Temp', 'Min Temp');
title('Max vs Min Temperature');
grid on;

%% 🔹 STEP 14: Summary
disp('--- Summary ---');
disp(['Mean Temp: ', num2str(meanTemp)]);
disp(['Max Temp: ', num2str(max(data.temp))]);
disp(['Min Temp: ', num2str(min(data.temp))]);
%% 🔹 SAVE ALL FIGURES TO PDF

figHandles = findall(0, 'Type', 'figure');

for i = 1:length(figHandles)
    exportgraphics(figHandles(i), 'CLIMATEDATA.pdf', ...
        'Append', true);
end