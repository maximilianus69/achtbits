function [ClusterFeatures, ClusterPoints] = createClusterFeatures( Cluster, SessionGpsData, SessionAccData )
% CREATE_CLUSTER_FEATURES creates a feature vector for a cluster
%
% Arguments:
%   - Cluster a 1x2 vector containing start and end times of the cluster
%   - SessionGpsData is the session gps data as created by readgps
%   - SessionAccData is the session acc data as created by readAcc
%
% Returns:
%   - ClusterFeatures array of features of this cluster
%   format: 
%   [startTime(s),  endTime(s),   duration(s), avgSpeed(km/h), ...
%    heightDiff(m), grndDist(km), totDist(km), angleVar(degrees/s), ...
%    distDiff(km), resolution(dat/min), fx(Hz), fy(Hz), fz(Hz), ...
%	 classSuggestion(id)]
%	- ClusterPoints a matrix with the points inside this cluster

% the maximum resolution to be used for calculating angle var
ANGLE_VAR_MAX_RES = 1.0;

% extract basic info
startTime = Cluster(1);
endTime = Cluster(2);
classSuggestion = -1;
if length(Cluster) < 3
	fprintf('WARNING: cluster does not have suggestion, this is a bug! Cluster time (%d, %d).\n', startTime, endTime);
else
	classSuggestion = Cluster(3);
end
duration = endTime - startTime;

% find start and end indices of the clusters
first = find(SessionGpsData(:,2) == startTime);
last = find(SessionGpsData(:,2) == endTime);

% data points inside cluster
Points = SessionGpsData(first:last, :);
if size(Points,1) < 2
	fprintf('ERROR: Cluster is too small or has no points in session!');
	return;
end
ClusterPoints = Points;

% default fourier data if none is found
fourierFreq = [-1 -1 -1];
% if there is acc data try to add fourier features
if size(SessionAccData) ~= [0 0]
	% extract part of accelerometer data inside cluster
	sessionAccTime = SessionAccData(:,2);
	afterStart = sessionAccTime >= startTime;
	beforeEnd = sessionAccTime <= endTime;
	ClusterAccData = SessionAccData(afterStart & beforeEnd, :);

	% get fourier analysis
	if size(ClusterAccData) ~= [0 0]
		% find the timestamp we want featured
	    accEntries = unique(ClusterAccData(:,2));
	    accEntry = ceil(length(accEntries)/2);
	    accTime = accEntries(accEntry);

	    % at least three acc entries are needed for this timestamp
	    numEntries = length(find(ClusterAccData(:,2) == accTime));
	    if	numEntries >= 3
	    	fourierFreq = fourierOnAcc(ClusterAccData, accTime);
	    end
	end
end

% holds the time passed between two sequential points
dt = Points(2:end,2) - Points(1:end-1,2);
if ~isempty(dt(dt < 0))
    print 'ERROR: the timestamps are non-sequential!';
    return;
end

% calculate resolution in datapoints per minute
resolution = size(ClusterPoints,1)/(duration/60);

% calculate avg speed
speeds = abs(Points(:,6)) + abs(Points(:,7));
avgSpeed = abs(mean(speeds)) * 3.6;

% calculate height differences per time unit (m)
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
speeds = speeds/norm(speeds);
% sample to the preferred resolution
sampled_dt = dt;
if resolution > ANGLE_VAR_MAX_RES
	numSamples = floor(ANGLE_VAR_MAX_RES * (duration/60));
	samples = floor(linspace(1, size(speeds,1), numSamples));
	speeds = speeds(samples,:);
	sampled_times = Points(samples,2);
	sampled_dt = sampled_times(2:end) - sampled_times(1:end-1);
end 
theta=0;
for i=1:size(speeds,1)-1
    % formula for calculating angle between 2 vectors in 3D
    theta(i) = atan2(norm(cross(speeds(i,:)',speeds(i+1,:)')),dot(speeds(i,:)',speeds(i+1,:)'));
end
dtheta = theta' ./ sampled_dt;
angleVar = abs(mean(dtheta))*(180/pi);

% calculate the difference between totDist and grndDist
distDiff = abs(totDist - grndDist);

% return data
ClusterFeatures = ...
    [startTime, endTime, duration, avgSpeed, heightDiff, grndDist, totDist, angleVar, distDiff, ...
    resolution, fourierFreq(1:3), classSuggestion];

end

