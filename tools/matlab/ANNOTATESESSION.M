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
        'diving'};
    
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
    'units','normalized','outerposition',[0 0.05 1 0.95]);

% session info
% add to seconds: 1199142000
sessionBeginTime = SessionGpsData(2, 1)*1000 + 1199142000;
sessionBeginTime = sessionBeginTime/24/3600;
datenum('1/1/1970','mm/dd/yyyy');
sessionBeginTime = sessionBeginTime + datenum('1/1/1970','mm/dd/yyyy');
datestr(sessionBeginTime);

% LAYOUT:

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
    
    subplot(5,7,[1:2 8:9 15:16]) %22:23
    plotTrajectory(SessionCoordinates, ClusterCoordinates);
    
    subplot(5, 7, [3:4 10:11 17:18])
    plotTrajectory(ClusterCoordinates);
    
    % plot data    
    subplot(5, 7, 22:25)
    plotVelAndAcc(ClusterData);
    
    % plot accelerometer data
    
    % 
    if size(SessionAccData) == [0 0]
        subplot(5, 7, 12:14)
        text(0.2, 0.5, 'No Accelerometer data found');
    else        
        plotClusterAcc(clusterTime, SessionAccData);
    end
    
    subplot(5,7,[26:27 33:34])
    
    % show features  
    plotFeatureInfo(ClusterFeatures, behaviourClasses);

    subplot(5,7,[28 35])
    
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

