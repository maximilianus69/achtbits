function out = createFeatureMatrix( deviceId )
%CREATE_FEATURE_MATRIX create a matrix with the features of 
%
% deviceId: string with the annotated device id
% method: learning method (TODO)


% The indices of the features to extract from cluster data
% Cluster format: 
%   [id, startTime(s), endTime(s), duration(s), avgSpeed(m/s), ...
%    heightDiff(m), grndDist(km), totDist(km), angleVar(deg/s), ...
%    distDiff(m), resolution(dat/min), fx(Hz), fy(Hz), fz(Hz), ...
%	 previousCluster(int), annotation(int)]
neededFeatures = [4:16];

% prepare data
folderPath = strcat('../annotatedData/real/device_', deviceId);
inputFilePrefix = strcat('/device_', deviceId, '_session_');
inputFileSuffix = '_clusterFeatures.csv';

sessionId = 0;
sessionFilePath = strcat(folderPath, inputFilePrefix, ...
    sprintf('%03d', sessionId), inputFileSuffix);
TrainingData = [];

while exist(sessionFilePath, 'file') == 2
    % read in data
    SessionClusters = dlmread(sessionFilePath, ',')
    TrainingData = [TrainingData; SessionClusters(:,neededFeatures)];
    
    % update filepath to next session
    sessionId = sessionId + 1;
    sessionFilePath = strcat(folderPath, inputFilePrefix, ...
    	sprintf('%03d', sessionId), inputFileSuffix);
end
out = TrainingData;

end
