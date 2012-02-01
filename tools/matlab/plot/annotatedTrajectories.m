function [ output_args ] = annotatedTrajectories( data )
%ANNOTATEDTRAJECTORIES Summary of this function goes here
%   Detailed explanation goes here


amountOfClusters = size(unique(data(:, 1)), 1);

for i = 1:amountOfClusters
    cluster = data(data(:,1) == i, :);
    
    switch cluster(1, 4)
        case 1
            color = 'blue';
        case 2
            % sleeping
            color = 'magenta';
        case 3
            % digesting
            color = 'cyan';
        case 4
            % flying
            color = 'red';
        case 5
            % hunting 
            color = 'black';
        case 6
            % bad cluster
            color = 'blue';
    end
    
    geoshow(gca, cluster(:, 2), cluster(:, 3), 'LineWidth', 1, 'color', color)

end

