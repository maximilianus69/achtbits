function [ output_args ] = plotVelAndAcc( SessionData, accPoints )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% get time and speed
time = SessionData(:, 2);
Speed = SessionData(:, 6:7);

N = size(time,1);

% normalize times to start at 0 and convert to zeros
beginTime = time(1);
timeNorm = (time - beginTime)/60;

x = timeNorm;
y = zeros(1, N);

% normalize speed
for i = 1:N
    y(i) = norm(Speed(i, :));
end

% plot speed
plot(x, y, '-s','LineWidth',1, ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','auto', ...
                'MarkerSize',4); 

hold on

% draw lines at each point that is plotted as accelero
sizeAcc = size(accPoints, 1);
if sizeAcc > 0
    line([timeNorm(accPoints) timeNorm(accPoints)], [0 max(y)], 'color', 'k')
end

% find the acceleration
Der = derivative([time Speed]);
timeDer = Der(:, 1);
Derivative = Der(:, 2);

timeOffset = (timeNorm(2) - timeNorm(1))/2;
beginTime = timeDer(1);
timeNorm = ((timeDer - beginTime)/60) + timeOffset;

N = size(timeNorm,1);
x = timeNorm;
y = Derivative;

%for i = 1:N
%    y(i) = norm(Derivative(i, :));
%end

plot(x, y, '-s','LineWidth',1, ...
                'Color', 'r', ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','g', ...
                'MarkerSize',4); 
            
title('Velocity and Acceleration');

hold off
   
end
