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

% for each cluster:
%   find the data and features
%   plot the trajectory, data and features
%   ask for user input (behaviour-class)
for i = 1:size(Clusters, 1)
    
    cluster = Clusters(i, :);
    [ClusterFeatures ClusterData] = ...
        createClusterFeatures(cluster, SessionData);
    
    % plot trajectory
    SessionCoordinates = SessionData(:, 3:4);
    ClusterCoordinates = ClusterData(:, 3:4);
    plotTrajectory(SessionCoordinates, ClusterCoordinates);
    
    % plot data
    plotClusterData(ClusterData);
    
    % show features  
    plotFeatureInfo(ClusterFeatures);
    
    % get behaviour input
    behaviour = showControls({'floating', 'flying', 'diving', 'trawler'});

    close all;
    
    AnnotatedClusters = [AnnotatedClusters; ClusterFeatures behaviour];
end

end

