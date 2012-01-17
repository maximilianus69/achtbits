function [ClusterFeatures, ClusterPoints] = createClusterFeatures( Cluster, Data )
% CREATE_CLUSTER_FEATURES Creates feature vectors for clusters
%
% Arguments:
%   - Clusters a 1x2 vector containing start and end times of the cluster
%   - Data is a NxM array containing all session data
%
% Returns:
%   Array of features of this cluster
%   format: 
%   [startTime, endTime, duration, avgSpeed, heightDiff, grndDist]

startTime = Cluster(1);
endTime = Cluster(2);
duration = endTime - startTime;

% find start and end indices of the clusters
first = find(Data(:,2) == startTime);
last = find(Data(:,2) == endTime);

% data points inside cluster
Points = Data(first:last, :);
ClusterPoints = Points;

% calculate avg speed
speeds = Points(:,6) + Points(:,7);
avgSpeed = mean(speeds);

% calculate hight diff
% TODO: remove noise in height data (extreme values)
heightDiff = max(Points(:,5)) - min(Points(:,5));

% calculate ground distance between begin point to end point
latDist = Points([1 end], 3);
longDist = Points([1 end], 4);
grndDist = deg2km(stdist(latDist, longDist));

% return data
ClusterFeatures = ...
    [startTime, endTime, duration, avgSpeed, heightDiff, grndDist];

end

