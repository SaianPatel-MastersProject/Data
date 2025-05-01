%%
yawRate = obj.data(1).lapData.steerAngle  .* -1.5;

%%
dX = [0; diff(obj.data(1).lapData.posX)];
dY = [0; diff(obj.data(1).lapData.posY)];
thetaV = atan2(dY, dX);

%%
yawAngle = zeros([numel(obj.data(1).lapData.tLap), 1]);
for i = 2:numel(yawAngle)

    % yawAngle(i,1) = yawAngle(i-1) + yawRate(i-1) * 0.01;
    yawAngle(i,1) = thetaV(i-1) + yawRate(i-1) * 0.01;


end

%%
dt = 0.2;
v = 40;
for i = 1:numel(yawAngle)
    % Predict yaw angle at future time
    yaw_future = (yawAngle(i) + yawRate(i) * dt);
    
    % Predict change in position
    dx = v * cos(yaw_future) * dt;
    dy = v * sin(yaw_future) * dt;
    
    % Predict future position
    x_future(i) = obj.data(1).lapData.posX(i) + dx;
    y_future(i) = obj.data(1).lapData.posY(i) + dy;
end

%%
figure;
hold on
plot(xRef, yRef)
scatter(obj.data(1).lapData.posX, obj.data(1).lapData.posY)
scatter(x_future, y_future)
axis equal