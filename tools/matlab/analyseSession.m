function Clusters = analyseSession( SessionData )
%ANALYSESESSION Finds the clusters in a session 
%   calculates the acceleration and uses this to determine cluster
%   start/end
%   output:
%   Clusters = nx2 matrix with start/end times 
%   [begin_t1 begin_t1; ... ; begin_tn begin_tn]

% *** maybe add more session analysis?***

% Threshold based on different time stamps
peakThres = 5;
% Threshold for time between peaks
timeThreshold = 1200;

% get time and speed
time = SessionData(:, 2);
Speed = SessionData(:, 6:7);

% find the acceleration
Der = derivative([time Speed]);

Derivative = Der(:, 2);


% find all threshold crossings
Clusters = findClusters(time, Derivative, peakThres);

% group sequences of small clusters into bigger ones
Clusters = awesomizeClusters(Clusters, timeThreshold);

end

