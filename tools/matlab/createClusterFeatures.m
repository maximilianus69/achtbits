function [ClusterFeatures, ClusterPoints] = createClusterFeatures( Cluster, Data )
% CREATE_CLUSTER_FEATURES Creates feature vectors for clusters
%
% Arguments:
%   - Cluster a 1x2 vector containing start and end times of the cluster
%   - Data is a NxM array containing all session data
%
% Returns:
%   Array of features of this cluster
%   format: 
%   [startTime(s),  endTime(s),   duration(s), avgSpeed(m/s), ...
%    heightDiff(m), grndDist(km), totDist(km), angleVar(rad), ...
%    distDiff(m),   resoanlution(min/dat)]

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
speeds = abs(Points(:,6)) + abs(Points(:,7));
avgSpeed = mean(speeds);

% calculate hight diff
% TODO: remove noise in height data (extreme values)
heightDiff = max(Points(:,5)) - min(Points(:,5));

% calculate ground distance between begin point to end point
latDist = Points([1 end], 3);
longDist = Points([1 end], 4);
grndDist = deg2km(stdist(latDist, longDist));

% calculate the total distance travelled
totDist = 0;
for i = 1:size(Points,1)-1
    lat = Points([i i+1], 3);
    lon = Points([i i+1], 4);
    totDist = totDist + deg2km(stdist(lat, lon));
end

% calculate the variance in direction
speeds = Points(:, 9:11);
speeds = speeds/norm(speeds); % only interested in angle
theta=0;
for i=1:size(speeds,1)-1
    theta(i) = atan2(norm(cross(speeds(i,:)',speeds(i+1,:)')),dot(speeds(i,:)',speeds(i+1,:)'));
end
angleVar = var(theta);
    
% calculate the difference between totDist and grndDist
distDiff = abs(totDist - grndDist);

% calculate resolution in datapoints per minute
resolution = size(ClusterPoints,1)/(duration/60);

% return data
ClusterFeatures = ...
    [startTime, endTime, duration, avgSpeed, heightDiff, grndDist, totDist, angleVar, distDiff, resolution];

end

