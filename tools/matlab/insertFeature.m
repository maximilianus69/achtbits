function NewFeatures = insertFeature(sessionId, feature)

% find id of feature to replace
% !! make sure this list is correct before insterting a feature
% !! insert features in the front of the list first
featureNames = {'startTime',  'endTime',   'duration', 'avgSpeed',   ...
    'heightDiff', 'grndDist', 'totDist', 'angleVar',   ...
    'distDiff',   'resolution',       'previousCluster', 'annotation'};
insertId = find(ismember(featureNames,feature) == 1);



% loop through annotated sessions
folderPath = strcat('../annotatedData/real/device_', deviceId);
inputFilePrefix = strcat('/device_', deviceId, '_session_');

sessionId = 0;
sessionFilePath = strcat(folderPath, inputFilePrefix, ...
    sprintf('%03d', sessionId), '_clusterFeatures.csv');

while exist(sessionFilePath, 'file') == 2
    % read in data
    SessionData = dlmread(sessionFilePath, ',');
    
    % loop through clusters
    for i = 1:size(SessionData,1)
        Cluster = SessionData(i,:);
        
        val = 0;
        if(strcmp(feature,'distDiff'))
            val = abs(Cluster(1,7)-Cluster(1,6)); 
        elseif(strcmp(feature,'resolution'))
            val = 0;
        end
    end

    sessionId = sessionId + 1;
    sessionFilePath = strcat(folderPath, inputFilePrefix, sprintf('%03d', sessionId), '_clusterFeatures.csv');
end



NewFeatures = zeros(size(OldFeatures,1), size(featureNames, 2));
NewFeatures(:,:insertId-1) = OldFeatures(:,:insertId-1));

