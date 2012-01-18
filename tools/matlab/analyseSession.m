function Clusters = analyseSession( SessionData )
%ANALYSESESSION Finds the clusters in a session 
%   calculates the acceleration and uses this to determine cluster
%   start/end

% *** maybe add more session analysis?***


% get time and speed
time = SessionData(:, 2);
Speed = SessionData(:, 6:7);

% find the acceleration
Der = derivative([time Speed]);

Derivative = Der(:, 2:3);

% Threshold based on different time stamps
%peakThres = 2*10^(-5);
peakThres = 0.015;

% find all threshold crossings
Clusters = findClusters(time, Derivative, peakThres);

% group sequences of small clusters into bigger ones
Clusters = awesomizeClusters(Clusters, 1200);

end

