function stopAnnotation = annotateSession( deviceId, sessionId, outputPath )
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


endOfSession = false;
stopAnnotation = true;
run = true;

behaviourClasses = {'unknown', 'sleeping', 'digesting', 'flying',...
        'diving', 'bad cluster'};

classColors = [[0 0 0]; [1 0 1]; [1 0.5 0]; [0 1 0]; [1 0 0]; [0 0 0]];

% read the session data from input file
SessionGpsData = readgps(deviceId, sessionId);

% read accelerometer data from file
SessionAccData = readAcc(deviceId, sessionId);

SessionGpsData = normalizeHeight(SessionGpsData);

% find clusters
Clusters = analyseSession(SessionGpsData);

dateTimeStart = timestampToDateTime(SessionGpsData(1, 2));

% initiate annotation GUI 

mainFigId = figure('Name',strcat('Cluster annotation, session ', ...
    sprintf('%03d', sessionId),', start: ', dateTimeStart),...
    'NumberTitle','off', 'units','normalized',...
    'outerposition',[0 0.05 1 0.90], 'DeleteFcn', {@exitTool});


% LAYOUT (organized in a 5x7 matrix containing subplots):

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

i = 1;
amountOfClusters = size(Clusters, 1);

annotatedData = []; % stores all features with class
annotatedTrajectory = []; % stores coordinates with class

% for each cluster:
%   find the data and features
%   plot the trajectory, data and features
%   ask for user input (behaviour-class)

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
    
    % get coordinates of session and cluster
    SessionCoordinates = SessionGpsData(:, 3:4);
    ClusterCoordinates = ClusterData(:, 3:4);
      
    % plot session trajectory
    subplot(5,7,[1:2 8:9 15:16])
    
    hold on
    plotTrajectory(SessionCoordinates, ClusterCoordinates);
    if i > 1
        annotatedTrajectories(annotatedTrajectory, classColors);
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
    
    % show features  
    subplot(5,7,[27:28 34:35])

    plotFeatureInfo(ClusterFeatures, behaviourClasses);
    
    % show control
    showControl

    % wait for a button to be clicked
    uiwait
     
end

close all;

% end of function

% nested functions used for button control

% showControl - places buttons with callback on the tool
    function showControl
        hp = uipanel('Position', [0 0 0.1 1], 'Title', 'control');

        hbgc = uibuttongroup('Parent', hp, 'Title', 'options', 'Position', [0 0.8 1 0.2]);
        hbs = makeButtons(hbgc, {'back', 'exit'});
        set(hbs(1), 'Callback', {@previousCluster});
        set(hbs(2), 'Callback', {@exitTool});

        hbgz = uibuttongroup('Parent', hp, 'Title', 'session zoom', 'Position', [0 0.55 1 0.2]);
        hbs = makeButtons(hbgz, {'Zoom in', 'Zoom out'});
        set(hbs(1), 'Callback', {@zoomSession, true});
        set(hbs(2), 'Callback', {@zoomSession, false});

        hbgc = uibuttongroup('Parent', hp, 'Title', 'classes', 'Position', [0 0 1 0.5]);
        hbs = makeButtons(hbgc, behaviourClasses, classColors);
        for j = 1:size(hbs, 1)
            set(hbs(j), 'Callback', {@updateBehaviour, j});
        end
        
    end

% zoomSession - replots the session trajectory zoomed or not
    function zoomSession(~, ~, zoom)
        subplot(5,7,[1:2 8:9 15:16])
        hold on
        plotTrajectory(SessionCoordinates, ClusterCoordinates, zoom);
        if i > 1
            annotatedTrajectories(annotatedTrajectory, classColors);
        end
        title('Session trajectory');
        hold off
    end

% exitTool - is called whenever the tool closes and stores result in a file
    function exitTool(~, ~)
        
        
        outputFile = strcat(outputPath, '/device_', deviceId, '_session_', ...
            sprintf('%03d', sessionId), '_clusterFeatures.csv');

        dlmwrite(outputFile, annotatedData, 'precision', '%10f');

        tempfig = figure();
        hold on
        annotatedTrajectory
        plotTrajectory(SessionCoordinates, ClusterCoordinates, true);
        if size(annotatedTrajectory, 1) > 1
            annotatedTrajectories(annotatedTrajectory, classColors);
        end
        title('Session trajectory');
        hold off
        print(tempfig, '-djpeg', strcat(outputPath, '/device_', deviceId, '_session_', ...
            sprintf('%03d', sessionId), '_sessionMap.jpeg'))
        close(tempfig)
        
        if ~endOfSession
            run = false;
        end
        
        uiresume
        
    end

% previousCluster - goes back one cluster
    function previousCluster(~, ~)
        
        if i > 1
            annotatedData = annotatedData(1:end-1, :);
            lastCluster = annotatedTrajectory(:, 1) == i-1;
            annotatedTrajectory(lastCluster, :) = [];
            i = i - 1;
        end
        
        uiresume
    end

% updateBehaviour - checks which class was specified and adds it to
% features
    function updateBehaviour(~, ~, behaviour)

        previousClusterClass = behaviour;

        % adds class to features and cluster to annotated clusters
        ClusterFeatures = [ClusterFeatures behaviour];

        annotatedData = [annotatedData; ClusterFeatures];
        
        clusterPoints = size(ClusterCoordinates, 1);
        
        % adds cluster XY with class to annotatedTrajectory
        temp = zeros(clusterPoints, 4);
        temp(1:clusterPoints, 1) = ClusterFeatures(1);
        temp(:, 2:3) = ClusterCoordinates;
        temp(1:clusterPoints, 4) = behaviour;
        annotatedTrajectory = [annotatedTrajectory;temp];

        uiresume;
        
        % checks if this was last cluster in session
        if i == amountOfClusters
            stopAnnotation = false;
            endOfSession = true;
        end
        
        i = i + 1;
    end

end

