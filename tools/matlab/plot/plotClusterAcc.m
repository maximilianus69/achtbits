function pointsShown = plotClusterAcc( clusterTime, SessionAccData )
%PLOTCLUSTERACC plots accelerometer data for cluster
%   
%   INPUT:
%   clusterTime     - [startTime endTime ..?] indicates start and end of
%                     cluster
%   sessionAccData  - [deviceId timeStamp time x y z]
%
%   OUTPUT:
%   pointsShown     - [first second thrid] position index of data points
%                     shown in accelerometer plots

pointsShown = [];

% finds all timestamps in SessionAccData also in cluster 
SessionAccTime = SessionAccData(:, 2);
afterStartCluster = SessionAccTime >= clusterTime(1);
beforeEndCluster = SessionAccTime <= clusterTime(2);
inCluster = afterStartCluster & beforeEndCluster;

if sum(inCluster) > 0

    % get the data that is in cluster
    ClusterAccData = SessionAccData(inCluster, 2:6);

    % get all time-stamps and find the right accelerometer points to use
    % for the plot depending on the amount of points in the cluster
    
    timeEntries = unique(ClusterAccData(:, 1));
    amountOfEntries = size(timeEntries, 1);
    if amountOfEntries == 1
        first = 1;
        second = 1;
        third = 1;
    elseif amountOfEntries == 2
        first = 1;
        second = 2;
        third = 2;
    elseif amountOfEntries == 3
        first = 1;
        second = 2;
        third = 3;
    elseif amountOfEntries == 4
        first = 2;
        second = 2;
        third = 3;
    else
        first = 2;
        second = round(amountOfEntries/2);
        third = amountOfEntries-1;
    end
    
    if second == 0
        pointsShown = [first third];
    else
        pointsShown = [first second third];
    end
    
    % plot each of the 3 points
    
    subplot(5, 7, 5:7)
    plotAcc(SessionAccData, timeEntries(first));
    title(strcat('Accelerometer of point ', num2str(first)));

    subplot(5, 7, 12:14)
    if second ~= 0
        plotAcc(SessionAccData, timeEntries(second));
        title(strcat('Accelerometer of point ', num2str(second)));
    end
    
    subplot(5, 7, 19:21)
    plotAcc(SessionAccData, timeEntries(third));
    title(strcat('Accelerometer of point ', num2str(third)));
    
else
    text(0.2, 0.5, 'No Accelerometer data found');
end

end

