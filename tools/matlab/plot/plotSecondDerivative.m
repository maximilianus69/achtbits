function result = plotSecondDerivative(Matrix, timeStamps, clusterStart)
% Arguments
%   - Matrix is an N x 3 matrix containing vectors
%   - TimeStamps is an N x 1 matrix containing timestamps (optional)
%   - clusterStart is an N x 1 matrix with clusterStart (optional)
%
% N is the number of datapoints. 
%
% Time is on the x-axis of the plot. The length of each vector is on the
% y-axis.

N = size(Matrix, 1);

if nargin < 2
    timeStamps = [1 : N];
end

if nargin < 3
    clusterStart = [];
end
cluster = clusterStart - timeStamps(1)
timeStamps = timeStamps - timeStamps(1);
x = timeStamps;
y = zeros(1, N);

for i = 1:N
    y(i) = norm(Matrix(i, :));
end

plot(x, y, '-s','LineWidth',1, ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','auto', ...
                'MarkerSize',4); 

xlabel('timestamp');
ylabel('length vector');
title('2nd derivative?');



hold on;
for p = 1:length(cluster)
    line([cluster(p) cluster(p)], [0 max(y)], 'Color','r');
end
hold off;

%':+', 'MarkerFaceColor', 'auto', 'MarkerSize', 10);
