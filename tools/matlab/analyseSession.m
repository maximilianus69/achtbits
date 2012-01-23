function Clusters = analyseSession( SessionData )
%ANALYSESESSION Finds the clusters in a session 
%   calculates the acceleration and uses this to determine cluster
%   start/end
%   output:
%   Clusters = nx2 matrix with start/end times 
%   [begin_t1 begin_t1; ... ; begin_tn begin_tn]

% *** maybe add more session analysis?***


% get time and speed
time = SessionData(:, 2);
Speed = SessionData(:, 6:7);

% find the acceleration
Der = derivative([time Speed]);

Derivative = Der(:, 2:3);

% Threshold based on different time stamps
peakThres = 0.015;

% find all threshold crossings
Clusters = findClusters(time, Derivative, peakThres);
% This puts the very last point as the last in the cluster
Clusters(size(Clusters, 1), 2) = time(size(time, 1))

% group sequences of small clusters into bigger ones
Clusters = awesomizeClusters(Clusters, 1200);

end

