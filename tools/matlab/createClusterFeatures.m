function [ClusterFeatures, ClusterPoints] = createClusterFeatures( Cluster, GpsData, AccData )
% CREATE_CLUSTER_FEATURES Creates feature vectors for clusters
%
% Arguments:
%   - Cluster a 1x2 vector containing start and end times of the cluster
%   - GpsData is the session gps data as created by readgps
%   - AccData is the session acc data as created by readAcc
%
% Returns:
%   Array of features of this cluster
%   format: 
%   [startTime(s),  endTime(s),   duration(s), avgSpeed(m/s), ...
%    heightDiff(m), grndDist(km), totDist(km), angleVar(degrees/s), ...
%    distDiff(m), resolution(dat/min), fourier(Hz)]

startTime = Cluster(1);
endTime = Cluster(2);
duration = endTime - startTime;

% get fourier analysis
%AccData(1:10,:)
%if size(AccData) ~= [0 0]
%    fourierOnAcc(AccData, startTime)
%end

% find start and end indices of the clusters
first = find(GpsData(:,2) == startTime);
last = find(GpsData(:,2) == endTime);

% data points inside cluster
Points = GpsData(first:last, :);
ClusterPoints = Points;

% holds the time passed between two sequential points
dt = Points(2:end,2) - Points(1:end-1,2);
if ~isempty(dt(dt < 0))
    print 'ERROR: the timestamps are non-sequential!');
end

% calculate avg speed
speeds = abs(Points(:,6)) + abs(Points(:,7));
avgSpeed = abs(mean(speeds)) * 3.6;

% calculate height differences per time unit (m/s)
dh = Points(2:end,5) - Points(1:end-1,5);
hDerv = dh ./ dt;
heightDiff = abs(mean(hDerv))*duration;

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

% calculate the variance in direction in average deg/s
speeds = Points(:, 9:11);
speeds = speeds/norm(speeds); % only interested in angle, not speed
theta=0;
for i=1:size(speeds,1)-1
    % formula for calculating angle between 2 vectors in 3D
    theta(i) = atan2(norm(cross(speeds(i,:)',speeds(i+1,:)')),dot(speeds(i,:)',speeds(i+1,:)'));
end
dtheta = theta' ./ dt;
angleVar = abs(mean(dtheta))*(180/pi);

% calculate the difference between totDist and grndDist
distDiff = abs(totDist - grndDist);

% calculate resolution in datapoints per minute
resolution = size(ClusterPoints,1)/(duration/60);

% return data
ClusterFeatures = ...
    [startTime, endTime, duration, avgSpeed, heightDiff, grndDist, totDist, angleVar, distDiff, resolution];

end

