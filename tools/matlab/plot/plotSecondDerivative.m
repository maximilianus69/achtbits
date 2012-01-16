function result = plotSecondDerivative(Matrix, TimeStamps, Peaks)
% Arguments
%   - Matrix is an N x 3 matrix containing vectors
%   - TimeStamps is an N x 1 matrix containing timestamps (optional)
%   - Peaks is an N x 1 matrix with Peaks (optional)
%
% N is the number of datapoints. 
%
% Time is on the x-axis of the plot. The length of each vector is on the
% y-axis.

N = size(Matrix, 1);

if nargin < 2
    TimeStamps = [1 : N];
end

if nargin < 3
    Peaks = [];
end

x = TimeStamps;
y = zeros(1, N);

for i = 1:N
    y(i) = norm(Matrix(i, :));
end

% in the future we can plot every awesome thingy in the same window 
% (we should create one function that plots everything
% h = subplot(1, 1, 1);

plot(x, y, '-s','LineWidth',1, ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','auto', ...
                'MarkerSize',4); 

xlabel('timestamp');
ylabel('length vector');
title('2nd derivative?');

hold on;
for p = 1:length(Peaks)
    Peaks(p);
    line([Peaks(p) Peaks(p)], [0 max(y)], 'Color','r');
end
hold off;

%':+', 'MarkerFaceColor', 'auto', 'MarkerSize', 10);
