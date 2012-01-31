function output = annotateSession( deviceId, sessionId, outputPath )
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



output = 'continue';
run = true;

behaviourClasses = {'unknown', 'sleeping', 'digesting', 'flying',...
        'diving', 'bad cluster'};
    
% read the session data from input file
SessionGpsData = readgps(deviceId, sessionId);

% read accelerometer data from file
SessionAccData = readAcc(deviceId, sessionId);

SessionGpsData = normalizeHeight(SessionGpsData);

% find clusters
Clusters = analyseSession(SessionGpsData);

dateTimeStart = timestampToDateTime(SessionGpsData(1, 2));

% initiate annotation GUI 

mainFigId = figure('Name',strcat('Cluster annotation, session ', sprintf('%03d', sessionId),', start: ', dateTimeStart), 'NumberTitle','off', ...
    'units','normalized','outerposition',[0 0.05 1 0.90], 'DeleteFcn', {@exitTool, false});


% LAYOUT:

% 1 - session trajectory
% 2 - cluster trajectory
% 3 - velocity and acceleration
% 4 - instantanious speed
% 5 - accelerometer data
% 6 - features
%
% [1 1 2 2 5 5 5]
% [1 1 2 2 5 5 5]
% [1 1 2 2 5 5 5]
% [3 3 3 3 3 6 6]
% [4 4 4 4 4 6 6]

% set previousClusterClass to unknown
previousClusterClass = 1;

% for each cluster:
%   find the data and features
%   plot the trajectory, data and features
%   ask for user input (behaviour-class)

i = 1;
amountOfClusters = size(Clusters, 1);

annotatedData = [];
annotatedTrajectory = [];

while i <= amountOfClusters
    clf %clearfigure

    % check if exit is prompted
    if ~run
        return
    end
    
    % get cluster features and data
    clusterTime = Clusters(i, :);
    [ClusterFeatures ClusterData] = ...
        createClusterFeatures(clusterTime, SessionGpsData, SessionAccData);
    
    ClusterFeatures = [i ClusterFeatures previousClusterClass];
    
    % plot trajectory
    SessionCoordinates = SessionGpsData(:, 3:4);
    ClusterCoordinates = ClusterData(:, 3:4);
      
    % plot session trajectory
    subplot(5,7,[1:2 8:9 15:16])
    hold on
    plotTrajectory(SessionCoordinates, ClusterCoordinates);
    if i > 1
        annotatedTrajectories(annotatedTrajectory);
    end
    title('Session trajectory');
    hold off
    
    % plot cluster trajectory
    subplot(5, 7, [3:4 10:11 17:18])
    hold on
    plotTrajectory(ClusterCoordinates);
    title('Cluster trajectroy');
    hold off
    
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
    
    % show control
    hp = uipanel('Position', [0 0 0.1 1], 'Title', 'control');
    
    % text(0, 0, strcat('Session: ', sprintf('%03d', sessionId)));
    
    % hpPosNorm = get(hp, 'Position')
    set(hp, 'Units', 'pixels');
    hpPos = get(hp, 'Position');
    set(hp, 'Units', 'normalized');
    buttonWidthMargin = hpPos(3)/20;
    buttonWidth = hpPos(3) - hpPos(3)/10 - 4;
    
    hbgc = uibuttongroup('Parent', hp, 'Title', 'options', 'Position', [0 0.5 1 0.3]);
    uicontrol('Parent', hbgc, 'Style', 'pushbutton', 'String', 'Back', ...
        'Callback', {@previousCluster}, 'Position', [buttonWidthMargin 130 buttonWidth 30])
    uicontrol('Parent', hbgc, 'Style', 'pushbutton', 'String', 'Exit', ...
        'Callback', {@exitTool, true}, 'Position', [buttonWidthMargin 90 buttonWidth 30])
    uicontrol('Parent', hbgc, 'Style', 'pushbutton', 'String', 'Zoom', ...
        'Callback', {@zoomSession}, 'Position', [buttonWidthMargin 10 buttonWidth 30])
    
    hbg = uibuttongroup('Parent', hp, 'Title', 'classes', 'Position', [0 0 1 0.5]);
    
    uicontrol('Parent', hbg, 'Style', 'pushbutton', 'String', 'unknown', ...
        'Callback', {@updateBehaviour, 1}, 'Position', [buttonWidthMargin 10 buttonWidth 30])
    uicontrol('Parent', hbg, 'Style', 'pushbutton', 'String', 'Sleeping', ...
        'Callback', {@updateBehaviour, 2}, 'Position', [buttonWidthMargin 50 buttonWidth 30])
    uicontrol('Parent', hbg, 'Style', 'pushbutton', 'String', 'Digesting', ...
        'Callback', {@updateBehaviour, 3}, 'Position', [buttonWidthMargin 90 buttonWidth 30])
    uicontrol('Parent', hbg, 'Style', 'pushbutton', 'String', 'Flying', ...
        'Callback', {@updateBehaviour, 4}, 'Position', [buttonWidthMargin 130 buttonWidth 30])
    uicontrol('Parent', hbg, 'Style', 'pushbutton', 'String', 'Hunting', ...
        'Callback', {@updateBehaviour, 5}, 'Position', [buttonWidthMargin 170 buttonWidth 30])
    uicontrol('Parent', hbg, 'Style', 'pushbutton', 'String', 'Bad cluster', ...
        'Callback', {@updateBehaviour, 6}, 'Position', [buttonWidthMargin 210 buttonWidth 30])
    
    uiwait
    
end
    
    function zoomSession(~, ~)
        subplot(5,7,[1:2 8:9 15:16])
        hold on
        plotTrajectory(SessionCoordinates, ClusterCoordinates, true);
        if i > 1
            annotatedTrajectories(annotatedTrajectory);
        end
        title('Session trajectory');
        hold off
    end

    function exitTool(~, ~, exitAll)
        
        outputFile = strcat(outputPath, '/device_', deviceId, '_session_', ...
            sprintf('%03d', sessionId), '_clusterFeatures.csv');

        dlmwrite(outputFile, annotatedData, 'precision', '%10f');
        
%         if i == 1
%             dlmwrite(outputFile, ClusterFeatures, 'precision', '%10f');
%         else
%             dlmwrite(outputFile, ClusterFeatures, '-append', 'roffset', 0, 'precision',  '%10f');
%         end
        if exitAll
            output = 'stop';   
            run = false;
        end
        uiresume
        
    end

    function previousCluster(~, ~)
        
        if i > 1
            annotatedData = annotatedData(1:end-1, :);
            i = i - 1;
        end
        
        uiresume
    end

    function updateBehaviour(~, ~, behaviour)

        previousClusterClass = behaviour;

        % add row to output
        ClusterFeatures = [ClusterFeatures behaviour];

        annotatedData = [annotatedData; ClusterFeatures];
        
        clusterPoints = size(ClusterCoordinates, 1);
        
        temp = zeros(clusterPoints, 4);
        temp(1:clusterPoints, 1) = ClusterFeatures(1);
        temp(:, 2:3) = ClusterCoordinates;
        temp(1:clusterPoints, 4) = behaviour;
        annotatedTrajectory = [annotatedTrajectory;temp];

        uiresume;

        i = i + 1;
    end

close all;

end

