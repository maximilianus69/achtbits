function [ AnnotatedClusters ] = annotateSession( fileName )
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

% read the session data from input file
SessionData = readgps(fileName);

% find clusters
Clusters = analyseSession(SessionData);

AnnotatedClusters = [];

screenSize = get(0, 'ScreenSize');
mainFigId = figure('Name','Cluster annotation', 'NumberTitle','off', ...
    'units','normalized','outerposition',[0 0 1 1]);
    
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
    
    % plot trajectory
    SessionCoordinates = SessionData(:, 3:4);
    ClusterCoordinates = ClusterData(:, 3:4);
    
    subplot(5,7,[1:2 8:9 15:16 22:23])
    plotTrajectory(SessionCoordinates, ClusterCoordinates);
    
    % plot data
    
    plotClusterData(ClusterData);
    
    subplot(5,7,29:33)
    
    % show features  
    plotFeatureInfo(ClusterFeatures);
    
    % get behaviour input
    subplot(5,7,34:35)
    behaviourClasses = {'sleeping', 'digesting', 'flying', 'diving', 'trawler'};
    behaviour = showControls(behaviourClasses);
    
    behaviourClasses(behaviour)
    
    %AnnotatedClusters = [AnnotatedClusters; ClusterFeatures behaviour];
end

close all;

end

