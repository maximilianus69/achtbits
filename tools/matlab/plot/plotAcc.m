function plotAcc(Accel, timeStamp)
% PLOTACC plots the accellerometer data of a certain time stamp
% Plots the x-axis red, y-axis green, z-axis blue
% INPUT:
% Accel - [deviceId dataTimestamp time x y z]
%         takes all time, x, y and z of given timestamp and plots them
% timeStamp - timeStamp of datapoint we want to plot
%

%find the entries that correspond to timeStamp
Accel = Accel(find(Accel(:, 2) ==  timeStamp), :);

% plot xyz in same plot
hold on

plot(Accel(:, 3), Accel(:, 4), 'LineWidth',1, 'color', 'r'); 
plot(Accel(:, 3), Accel(:, 5), 'LineWidth',1, 'color', 'b'); 
plot(Accel(:, 3), Accel(:, 6), 'LineWidth',1, 'color', 'g'); 

hold off
end
