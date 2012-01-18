function [ output_args ] = plotClusterData( SessionData )
%PLOTCLUSTERDATA Plots all relevant ClusterData and features for annotation
%   Detailed explanation goes here

% plot the speed
% figId = figure('Position', [340 40 500 360]);

% get time and speed
time = SessionData(:, 2);
Speed = SessionData(:, 6:7);
height = SessionData(:, 5);

subplot(5, 7, 3:7)
plotSecondDerivative('velocity', Speed, time);

% find the acceleration
Der = derivative([time Speed]);
timeDer = Der(:, 1);
Derivative = Der(:, 2:3);
% plot all the clusters

subplot(5, 7, 10:14);
plotSecondDerivative('acceleration', Derivative, timeDer);


beginTime = time(1);
time = (time - beginTime)/60;

subplot(5, 7, 17:21);

plot(time, height, '-s','LineWidth',1, ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','auto', ...
                'MarkerSize',4); 
title('Height');    
end

