function [ SessionGpsData AnnotatedClusters ] = annotateSession( deviceId, sessionId, outputPath)
%ANNOTATESESSION a tool to annote the clusters of a session
%
%   INPUT:
%   fileName - session CSV file
%
%   OUTPUT:
%   AnnotatedClusters - [ClusterFeatures Behaviour]
%
%   - Finds all clusters and calculates their features
%   - (Plots the trajectory and session data)
%   - loops through clusters:
%       - plot data of cluster
%       - user can input annotation for cluster

behaviourClasses = {'unknown', 'sleeping', 'digesting', 'flying',...
        'diving', 'trawler'};
    
AnnotatedClusters = [];
    
% read the session data from input file
SessionGpsData = readgps(deviceId, sessionId);

% read accelerometer data from file
SessionAccData = readAcc(deviceId, sessionId);

%SessionGpsData = normalizeHeight(SessionGpsData);

% find clusters
Clusters = analyseSession(SessionGpsData);

% initiate annotation GUI 
screenSize = get(0, 'ScreenSize');
mainFigId = figure('Name','Cluster annotation', 'NumberTitle','off', ...
    'units','normalized','outerposition',[0 0 1 1]);

% session info
% add to seconds: 1199142000

% 1 - trajectory
% 2 - velocity
% 3 - acceleration
% 4 - height
% 5 - accelero?
% 6 - features
% 7 - input (clickable)
%
% [1 1 2 2 2 2 2]
% [1 1 3 3 3 3 3]
% [1 1 4 4 4 4 4]
% [1 1 5 5 5 7 7]
% [6 6 6 6 6 7 7]

% set previousClusterClass to unknown
previousClusterClass = 1;

% for each cluster:
%   find the data and features
%   plot the trajectory, data and features
%   ask for user input (behaviour-class)
for i = 1:size(Clusters, 1)
    clf %clearfigure
    
    % get cluster features and data
    clusterTime = Clusters(i, :);
    [ClusterFeatures ClusterData] = ...
        createClusterFeatures(clusterTime, SessionGpsData);
    
    ClusterFeatures = [i ClusterFeatures previousClusterClass];
    
    % plot trajectory
    SessionCoordinates = SessionGpsData(:, 3:4);
    ClusterCoordinates = ClusterData(:, 3:4);
    
    subplot(5,7,[1:2 8:9 15:16 22:23])
    plotTrajectory(SessionCoordinates, ClusterCoordinates);
    
    % plot data    
    plotClusterData(ClusterData);
    
    % plot accelerometer data
    
    if size(SessionAccData) == [0 0]
        text(100, 100, 'No Accelerometer data found');
    else
        subplot(5, 7, 24:26)
        plotClusterAcc(clusterTime, SessionAccData);
        subplot(5, 7, 31:33)
        %subplot(5, 7, 24:26)
    end
    
    subplot(5,7,29:30)
    
    % show features  
    plotFeatureInfo(ClusterFeatures, behaviourClasses);

    subplot(5,7,[27:28 34:35])
    
    % get behaviour input
    behaviour = showControls(behaviourClasses);
    
    previousClusterClass = behaviour;
    
    % add row to output
    ClusterFeatures = [ClusterFeatures behaviour];
    AnnotatedClusters = [AnnotatedClusters; ClusterFeatures behaviour];
    
    % write features to file
    
    outputFile = strcat(outputPath, '/device_', deviceId, '_session_', ...
        sprintf('%03d', sessionId), '_clusterFeatures.csv');
    
    if i == 1
        dlmwrite(outputFile, ClusterFeatures);
    else
        dlmwrite(outputFile, ClusterFeatures, '-append', 'roffset', 0);
    end
end

close all;

end

