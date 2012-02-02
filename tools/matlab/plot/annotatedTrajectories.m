function annotatedTrajectories( annotatedData, classColors )
%ANNOTATEDTRAJECTORIES colorcodes all annotated clusters
%   Detailed explanation goes here


amountOfClusters = size(unique(annotatedData(:, 1)), 1);

for i = 1:amountOfClusters
    cluster = annotatedData(annotatedData(:,1) == i, :);
    color = classColors(cluster(1, 4), :);
    
    geoshow(gca, cluster(:, 2), cluster(:, 3), 'LineWidth', 1, 'color', color)
end

end

