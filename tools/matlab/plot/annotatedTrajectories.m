function [ output_args ] = annotatedTrajectories( data, classColors )
%ANNOTATEDTRAJECTORIES Summary of this function goes here
%   Detailed explanation goes here


amountOfClusters = size(unique(data(:, 1)), 1);

for i = 1:amountOfClusters
    cluster = data(data(:,1) == i, :);
    color = classColors(cluster(1, 4), :);
    
    geoshow(gca, cluster(:, 2), cluster(:, 3), 'LineWidth', 1, 'color', color)
end

end

