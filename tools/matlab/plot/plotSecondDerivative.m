function result = plotSecondDerivative(label, Matrix, timeStamps, clusterStart)
% Arguments
%   - label is the label for the plot
%   - Matrix is an N x 3 matrix containing vectors
%   - TimeStamps is an N x 1 matrix containing timestamps (optional)
%   - clusterStart is an N x 1 matrix with clusterStart (optional)
%
% N is the number of datapoints. 
%
% Time is on the x-axis of the plot. The length of each vector is on the
% y-axis.

N = size(Matrix, 1);

if nargin < 3
    timeStamps = [1 : N];
end

if nargin < 4
    clusterStart = [];
end

% normalize times to start at 0 and convert to zeros
beginTime = timeStamps(1);
cluster = (clusterStart - beginTime)/60;
timeStamps = (timeStamps - beginTime)/60;

x = timeStamps;
y = zeros(1, N);

for i = 1:N
    y(i) = norm(Matrix(i, :));
end

plot(x, y, '-s','LineWidth',1, ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','auto', ...
                'MarkerSize',4); 

%xlabel('timestamp');
%ylabel('length vector');
title(label);

% draw a vertical line at the start/end of all clusters
hold on;
for p = 1:length(cluster)
    line([cluster(p) cluster(p)], [0 max(y)], 'Color','r');
end
hold off;

%':+', 'MarkerFaceColor', 'auto', 'MarkerSize', 10);
