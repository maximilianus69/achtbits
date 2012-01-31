function [clustersTimestampsStart, clustersTimestampsEnd] = completeClusters(timestamps, labels, minimumClusterLengthSeconds)
% Creates a N x 2 matrix with start time - end time tuples of found clusters
%
% There are a couple of cases:
% * 1 cluster smoothly transfers from one label to another (one cluster ends another starts)
% * There is a cluster that is smaller than 'minimumClusterLengthSeconds' between two 
% good clusters (cut this cluster in two, add the first halve to the previous cluster and 
% the second halve to the next cluster). Or, if the previous cluster label is the same
% as the next cluster label, simply concenate those two to one cluster.
% * There are a couple of clusters too small. Concenate these so they form one cluster
% that is longer than 'minimumClusterLengthSeconds'. If it can't be made longer thans
% 'minimumClusterLengthSeconds', delete them all. 
%
% IN: 
%   timestamps: vector with ALL timestamps
%   labels: the label for each timestamp from timestamps
%   minimumClusterLengthSeconds: minimum length of a cluster in seconds
%
% OUT:
%   a vector with timestamps that indicate a beginning of a cluster
%   a vector with timestamps that indicate an ending of a cluster

labels = labels

% finding timestamps of unprocessed clusters
clusterBordersTimestamps(1, 1) = timestamps(1);
clusterBordersTimestamps(1, 2) = 1;
clusterCount = 2;
oldLabel = labels(1);
for x = 2:size(labels, 1)
    % case 1
    if oldLabel ~=  labels(x)
        clusterBordersTimestamps(clusterCount, :) = [timestamps(x) x];
        clusterCount = clusterCount + 1;
        oldLabel = labels(x); 
    end
end


clusterBordersTimestamps

%currentCluster = 1;
%oldLabel = labels(1);
%clustersTimestampsStart(1, :) = timestamps(1);
%%clustersTimestampsEnd;
%
%for x = 2:size(labels, 1)
%    % case 1
%    if oldLabel ~=  labels(x)
%        oldLabel = labls(x); 
%    end
%end



currentCluster = 1;
clustersTimestampsStart(1, :) = timestamps(1);
clustersTimestampsEnd(1, :) = timestamps(size(timestamps, 1));
clusterCount = 1;

for x = 1:size(clusterBordersTimestamps, 1) - 2
    %if clustersTimestampsStart(x, 1) > 0 % <- what is this? 
        clustersTimestampsStart(clusterCount) = clusterBordersTimestamps(x, 1);
        % if a cluster is too short
        if (clusterBordersTimestamps(x + 1, 1) - clusterBordersTimestamps(x, 1)) < minimumClusterLengthSeconds 
            % if the next cluster isn't too short
            if clusterBordersTimestamps(x + 2, 1) - clusterBordersTimestamps(x + 1, 1) > minimumClusterLengthSeconds
                % if previous and next are the same cluster
                if x > 1 and labels(clusterBordersTimestamps(x - 1, 2)) == labels(clusterBordersTimestamps(x + 1, 2))
                    % in which case we do nothing, 
                    % set labels to the same
                    % remove the next cluster border (set to negative value)
                    lowerIndex = clusterBordersTimestamps(x, 2);
                    upperIndex = clusterBordersTimestamps(x + 1, 2);
                    labels(lowerIndex : upperIndex) = ones(upperIndex - lowerIndex - 1, 1) .* labels(lowerIndex - 1);
                    clusterBordersTimestamps(x+1, 1) = -1; 
                % otherwise 
                else
                    % split in two
                    lowerIndex = clusterBordersTimestamps(x, 2);
                    upperIndex = clusterBordersTimestamps(x + 1, 2);
                    middleIndex = round(upperIndex - lowerIndex / 2);
                    clustersTimestampsEnd(clusterCount) = timestamps(middleIndex);
                    clustersTimestampsStart(clusterCount + 1) = timestamps(middleIndex);
                    labels(lowerIndex : middleIndex) = ones(middleIndex - lowerIndex - 1, 1) .* labels(lowerIndex - 1);
                    labels(middleIndex : upperIndex) = ones(upperIndex - lowerIndex, - 1, 1) .* labels(upperIndex + 1);
                end
            end
        end
        clustersTimestampsEnd(clusterCount) = clusterBordersTimestamps(x, 1);
        clusterCount = clusterCount + 1;
    %end
end

clustersTimestampsStart = clustersTimestampsStart
clustersTimestampsEnd = clustersTimestampsEnd
