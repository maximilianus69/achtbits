function out = createFeatureMatrix( deviceId )
%TRAIN perform machine learning on data
%
% deviceId: string with the annotated device id
% method: learning method (TODO)


% Get indices of needed features,
%   format: 
%   [i, startTime(s),  endTime(s),   duration(s), avgSpeed(m/s),   ...
%    heightDiff(m), grndDist(km), totDist(km), angleVar(rad),   ...
%    distDiff(m),   resolution(min/dat),       previousCluster, ...
%    annotation]
neededFeatures = [4:11];

% prepare data
folderPath = strcat('../annotatedData/real/device_', deviceId);
inputFilePrefix = strcat('/device_', deviceId, '_session_');

sessionId = 0;
sessionFilePath = strcat(folderPath, inputFilePrefix, ...
    sprintf('%03d', sessionId), '_clusterFeatures.csv');
TrainingData = [];

while exist(sessionFilePath, 'file') == 2
    % read in data
    SessionClusters = dlmread(sessionFilePath, ',');
    TrainingData = [TrainingData; SessionClusters(:,neededFeatures)];
    
    sessionId = sessionId + 1;
    sessionFilePath = strcat(folderPath, inputFilePrefix, sprintf('%03d', sessionId), '_clusterFeatures.csv');
end
out = TrainingData;

end
