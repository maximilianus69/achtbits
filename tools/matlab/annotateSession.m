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
        'diving', 'bad cluster'};
    
AnnotatedClusters = [];
    
% read the session data from input file
SessionGpsData = readgps(deviceId, sessionId);

% read accelerometer data from file
SessionAccData = readAcc(deviceId, sessionId);

%SessionGpsData = normalizeHeight(SessionGpsData);

% find clusters
Clusters = analyseSession(SessionGpsData);

dateTimeStart = timestampToDateTime(SessionGpsData(1, 2));

% initiate annotation GUI 
screenSize = get(0, 'ScreenSize');
mainFigId = figure('Name',strcat('Cluster annotation, session start: ', dateTimeStart), 'NumberTitle','off', ...
    'units','normalized','outerposition',[0 0.05 1 0.95], 'Position', [0 0 1 1]);


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
        createClusterFeatures(clusterTime, SessionGpsData, SessionAccData);
    
    ClusterFeatures = [i ClusterFeatures previousClusterClass];
    
    % plot trajectory
    SessionCoordinates = SessionGpsData(:, 3:4);
    ClusterCoordinates = ClusterData(:, 3:4);
    
    subplot(5,7,[1:2 8:9 15:16])
    % subplot('Position',[0 0.95 0.1 0.1])
    plotTrajectory(SessionCoordinates, ClusterCoordinates);
    title('Session trajectory');
    
    subplot(5, 7, [3:4 10:11 17:18])
    plotTrajectory(ClusterCoordinates);
    title('Cluster trajectroy');
    
    % plot accelerometer data
    subplot(5, 7, 5:7)
    if size(SessionAccData) == [0 0]
        text(0.2, 0.5, 'No Accelerometer data found');
        accPoints = [];
    else        
        accPoints = plotClusterAcc(clusterTime, SessionAccData);
    end
    
    % plot velocity and acceleration   
    subplot(5, 7, 22:26)
    plotVelAndAcc(ClusterData, accPoints);
        
    % plot instantanious speed vectors
    subplot(5, 7, 29:33);
    plotInstantSpeed(ClusterData);
    
    subplot(5,7,[27:28 34:35])
     
    % show features  
    plotFeatureInfo(ClusterFeatures, behaviourClasses);
    
    % get behaviour input

    behaviour = menu('choose a class', behaviourClasses);
    
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
        dlmwrite(outputFile, ClusterFeatures, '-append', 'roffset', 0, 'precision',  '%10f');
    end
end

close all;

end

