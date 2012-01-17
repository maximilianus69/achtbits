function [ output_args ] = plotClusterData( SessionData )
%PLOTCLUSTERDATA Plots all relevant ClusterData and features for annotation
%   Detailed explanation goes here

% plot the speed
figId = figure('Position', [340 40 500 360]);

% get time and speed
time = SessionData(:, 2)
Speed = SessionData(:, 6:7);

subplot(2, 1, 1)

plotSecondDerivative('velocity', Speed, time);

% find the acceleration
Der = derivative([time Speed]);
time = Der(:, 1)
Derivative = Der(:, 2:3)
% plot all the clusters
subplot(2,1,2);
plotSecondDerivative('acceleration', Derivative, time);
    
end

