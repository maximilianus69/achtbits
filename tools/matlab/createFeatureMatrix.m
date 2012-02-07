function [TrainingData, labels] = createFeatureMatrix( deviceId )
%CREATE_FEATURE_MATRIX create a matrix with the features of 
%
% Arguments:
% 	- deviceId string of the device-id of a bird with real-annotated data
%
% Returns:
%	- TrainingData matrix with features of the bird.
%	- labels cell array of labels corresponding to features columns 

labels = {'duration','avg_speed','height_diff','grnd_dist','tot_dist', ...
		'angle_var','dist_diff','resolution','fx','fy','fz', ...
		'class_suggestion', 'prev_cluster'};

% The indices of the features to extract from cluster data
% Cluster format: 
%   [id, startTime(s), endTime(s), duration(s), avgSpeed(km/h), ...
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
    SessionClusters = dlmread(sessionFilePath, ',');
    TrainingData = [TrainingData; SessionClusters(:,neededFeatures)];
    
    % update filepath to next session
    sessionId = sessionId + 1;
    sessionFilePath = strcat(folderPath, inputFilePrefix, ...
    	sprintf('%03d', sessionId), inputFileSuffix);
end