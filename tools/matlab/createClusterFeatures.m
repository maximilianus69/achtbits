function ClusterFeatures = createClusterFeatures( Cluster, Data )
% CREATE_CLUSTER_FEATURES Creates feature vectors for clusters
%
% Arguments:
%   - Clusters a 1x2 vector containing start and end times of the cluster
%   - Data is a NxM array containing all session data
%
% Returns:
%   Array of features of this cluster
%   format: [startTime, endTime, duration, avg speed, height diff]

startTime = Cluster(1);
endTime = Cluster(2);
duration = endTime - startTime;

% find start and end indices of the clusters
first = find(Data(:,2) == startTime);
last = find(Data(:,2) == endTime);

% data points inside cluster
Points = Data(first:last, :);

% calculate avg speed
speeds = Points(:,6) + Points(:,7);
avgSpeed = mean(speeds);

% calculate hight diff
% TODO: remove noise in height data (extreme values)
heightDiff = max(Points(:,5)) - min(Points(:,5));

% return data
% format: [startTime, endTime, duration, avg speed, height diff]
ClusterFeatures = ...
    [startTime, endTime, duration, avgSpeed, heightDiff];

end

