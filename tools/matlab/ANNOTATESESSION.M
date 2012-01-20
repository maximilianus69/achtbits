function [ SessionData AnnotatedClusters ] = annotateSession( deviceId, sessionId, fileName, outputPath, outputFileName)
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
SessionData = readgps(fileName);

% SessionData = normalizeHeight(SessionData);

% write sessionData to file (not included now)

% dlmwrite(strcat(outputPath, '\', outputFileName, '_sessionData.csv'), SessionData);

% find clusters
Clusters = analyseSession(SessionData);

screenSize = get(0, 'ScreenSize');
mainFigId = figure('Name','Cluster annotation', 'NumberTitle','off', ...
    'units','normalized','outerposition',[0 0 1 1]);

% set previousClusterClass to unknown
previousClusterClass = 1;

% for each cluster:
%   find the data and features
%   plot the trajectory, data and features
%   ask for user input (behaviour-class)
for i = 1:size(Clusters, 1)
    
    clf %clearfigure
    
    % get cluster features and data
    cluster = Clusters(i, :);
    [ClusterFeatures ClusterData] = ...
        createClusterFeatures(cluster, SessionData);
    
    ClusterFeatures = [i ClusterFeatures previousClusterClass];
    
    % plot trajectory
    SessionCoordinates = SessionData(:, 3:4);
    ClusterCoordinates = ClusterData(:, 3:4);
    
    subplot(5,7,[1:2 8:9 15:16 22:23])
    plotTrajectory(SessionCoordinates, ClusterCoordinates);
    
    % plot data    
    plotClusterData(ClusterData);
    
    subplot(5,7,29:33)
    
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
    
    outputFileFeatures = strcat(outputPath, '/', outputFileName,...
        '_clusterFeatures.csv');
    
    if i == 1
        dlmwrite(outputFileFeatures, ClusterFeatures);
    else
        dlmwrite(outputFileFeatures, ClusterFeatures, '-append', 'roffset', 0);
    end
end

close all;

end

