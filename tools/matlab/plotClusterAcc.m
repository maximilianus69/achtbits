function pointsShown = plotClusterAcc( clusterTime, SessionAccData )
%PLOTCLUSTERACC plots accelerometer data for cluster
%   Detailed explanation goes here

pointsShown = [];

% finds all timestamps in SessionAccData also in cluster 
SessionAccTime = SessionAccData(:, 2);
afterStartCluster = SessionAccTime >= clusterTime(1);
beforeEndCluster = SessionAccTime <= clusterTime(2);
inCluster = afterStartCluster & beforeEndCluster;


if sum(inCluster) > 0

    % get the data that is in cluster
    ClusterAccData = SessionAccData(inCluster, 2:6);

    % get all time-stamps and find the middle one
    timeEntries = unique(ClusterAccData(:, 1));

    amountOfEntries = size(timeEntries, 1);
    
    if amountOfEntries == 2
        time1 = timeEntries(1);
        time2 = 0;
        time3 = timeEntries(3);
        pointsShown = [1 3];
    elseif amountOfEntries == 3
        time1 = timeEntries(1);
        time2 = timeEntries(2);
        time3 = timeEntries(3);
        pointsShown = [1 2 3];
    elseif amountOfEntries == 4
        time1 = timeEntries(2);
        time2 = 0;
        time3 = timeEntries(3);
        pointsShown = [2 3];
    else
        time1 = timeEntries(2);
        middle = round(amountOfEntries/2);
        time2 = timeEntries(middle);
        penultimate = amountOfEntries-1;
        time3 = timeEntries(penultimate);
        pointsShown = [2 middle penultimate];
    end
    
    subplot(5, 7, 5:7)
    plotAcc(SessionAccData, time1);
    
    subplot(5, 7, 12:14)
    if time2 ~= 0
        plotAcc(SessionAccData, time2);
    end
    subplot(5, 7, 19:21)
    plotAcc(SessionAccData, time3);
else
    text(0.2, 0.5, 'No Accelerometer data found');
end

end

