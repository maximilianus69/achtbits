function [ output_args ] = plotClusterAcc( clusterTime, SessionAccData )
%PLOTCLUSTERACC plots accelerometer data for cluster
%   Detailed explanation goes here

% finds all timestamps in SessionAccDatam also in cluster 
SessionAccTime = SessionAccData(:, 2);
afterStartCluster = SessionAccTime >= clusterTime(1);
beforeEndCluster = SessionAccTime <= clusterTime(2);
inCluster = afterStartCluster & beforeEndCluster;

% get the data thawt is in cluster
ClusterAccData = SessionAccData(inCluster, 2:6);

% get all time-stamps and find the middle one
timeEntries = unique(ClusterAccData(:, 1));
timeToShow = timeEntries(round(size(timeEntries, 1)/2));
isEntryToShow = ClusterAccData == timeToShow; 

% get the data of the correct time stamp
entriesToShow = ClusterAccData(isEntryToShow, 2:5);

% plot the data
x = entriesToShow(:, 1);

hold('on')
plot(x, entriesToShow(:, 2), 'color', 'red')

plot(x, entriesToShow(:, 3), 'color', 'green')

plot(x, entriesToShow(:, 4), 'color', 'blue')

title('accelerometer');

hold('off')
end

