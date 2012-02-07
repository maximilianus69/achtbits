function NewClusters = interpolatedToRealTimestamp(Clusters, realTimestamps)
    % INTERPOLATEDTOREALTIMESTAMP: returns the timestamps as they are in the original session data
    % Input: Clusters, realTimestamps
    % Output: NewClusters, an array consisting of the clusters that are put in,
    % but with timestamps that are in the original data, so not in the
    % interpolated data.
    NewClusters = [];
    for i = 1:size(Clusters, 2)
        for j = 1:size(Clusters, 1)
            [trash index] = min(abs(realTimestamps - Clusters(j, i)));
            NewClusters(j, i) = realTimestamps(index);
        end
    end
        
    


