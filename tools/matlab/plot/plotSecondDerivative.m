function result = plotSecondDerivative(Matrix)
% Argument Matrix is an N x 3 matrix containing vectors>
% N is the number of datapoints. 
%
% Time is on the x-axis of the plot. The length of each vector is on the
% y-axis.

N = size(Matrix, 1);

x = [1 : N];
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

xlabel('index');
ylabel('length vector');
title('2nd derivative?');


%':+', 'MarkerFaceColor', 'auto', 'MarkerSize', 10);
