%% Improving HE calculation

%% Load Data
obj = Plotting.multiPlotter();
obj = obj.addLap('D:\Users\Saian\Workspace\Data\+ProcessedData\2025\FYP02_03\2025_FYP02_03_D1_R02.mat', 31); % Human

%% Get positional data
x = obj.data(1).lapData.posX;
y = obj.data(1).lapData.posY;

nEntries = size(x, 1);

dx = [0; diff(x)];
dy = [0; diff(y)];

dx_2 = dx;
dy_2 = dy;
% Calculate differences using 5 points back instead
for i = 3:nEntries

    dx_2(i) = (x(i) - x(i-2)) / 2;
    dy_2(i) = (y(i) - y(i-2)) / 2;


end

dx_5 = dx;
dy_5 = dy;
% Calculate differences using 5 points back instead
for i = 6:nEntries

    dx_5(i) = (x(i) - x(i-5)) / 5;
    dy_5(i) = (y(i) - y(i-5)) / 5;


end

dx_10 = dx;
dy_10 = dy;
% Calculate differences using 5 points back instead
for i = 11:nEntries

    dx_10(i) = (x(i) - x(i-10)) / 10;
    dy_10(i) = (y(i) - y(i-10)) / 10;


end

%% Plot results

figure;
subplot(3,1,1)
plot(x)

subplot(3,1,2)
plot(y)

subplot(3,1,3)
plot(HE)

figure;
subplot(2,2,1)
hold on
plot(dx, 'Color', 'k')
plot(dx_2, 'Color', 'g')
plot(dx_5, 'Color', 'b')
plot(dx_10, 'Color', 'r')

subplot(2,2,2)
hold on
plot([0; diff(dx)], 'Color', 'k')
plot([0; diff(dx_2)], 'Color', 'g')
plot([0; diff(dx_5)], 'Color', 'b')
plot([0; diff(dx_10)], 'Color', 'r')


subplot(2,2,3)
hold on
plot(dy, 'Color', 'k')
plot(dy_2, 'Color', 'g')
plot(dy_5, 'Color', 'b')
plot(dy_10, 'Color', 'r')

subplot(2,2,4)
hold on
plot([0; diff(dy)], 'Color', 'k')
plot([0; diff(dy_2)], 'Color', 'g')
plot([0; diff(dy_5)], 'Color', 'b')
plot([0; diff(dy_10)], 'Color', 'r')