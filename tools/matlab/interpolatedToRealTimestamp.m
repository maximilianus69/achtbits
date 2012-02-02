function NewClusters = interpolatedToRealTimestamp(Clusters, realTimestamps)
    NewClusters = [];
    for i = 1:size(Clusters, 2)
        for j = 1:size(Clusters, 1)
            [trash index] = min(abs(realTimestamps - Clusters(j, i)));
            NewClusters(j, i) = realTimestamps(index);
        end
    end
        
    


