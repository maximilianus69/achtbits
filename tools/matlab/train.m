function out = train( deviceId, method )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Get indices of needed features,
%   format: 
%   [startTime(s),  endTime(s),   duration(s), avgSpeed(m/s),   ...
%    heightDiff(m), grndDist(km), totDist(km), angleVar(rad),   ...
%    distDiff(m),   resolution(min/dat),       previousCluster, ...
%    annotation]
neededFeatures = [3 4 5 6 7 8 9 10 11 12];

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

