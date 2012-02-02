function exitBeforeEnd = annotateSession( deviceId, sessionId, outputPath )
%ANNOTATESESSION a tool to annote the clusters of a session and write them
%                to file
%
%   INPUT:
%   deviceId        - string, ID number of the device
%   startSession    - integer, ID of the session
%   outputPath      - string, a directory in which to store annotated data
%
%   OUTPUT:
%   exitBeforeEnd    - boolean, true if the tool was closed before the end 
%                     of the session
%
%   - Finds all clusters and calculates their features
%   - Plots the trajectory of the session
%   - loops through clusters:
%       - plot data of cluster
%           - trajectory
%           - velocity and acceleration
%           - instantanious speed and direction
%           - accelerometer XYZ (if available)
%           - features
%       - user can input annotation for cluster  

% booleans used to keep track of how the session was ended
exitBeforeEnd = true;
run = true;

annotatedData = []; % stores all clusters with features and class
annotatedTrajectory = []; % stores coordinates with class

% list of classes used to annotate clusters
behaviourClasses = {'unknown', 'sleeping', 'digesting', 'flying',...
        'diving', 'bad cluster'};

% a list of colorcodings for the classes
classColors = [[0 0 0]; [1 0 1]; [1 0.5 0]; [0 1 0]; [1 0 0]; [0 0 0]];

% read the session data from input file
SessionGpsData = readgps(deviceId, sessionId);

% read accelerometer data from file
SessionAccData = readAcc(deviceId, sessionId);

SessionGpsData = normalizeHeight(SessionGpsData);

% find clusters
Clusters = analyseSession(SessionGpsData);

dateTimeStart = timestampToDateTime(SessionGpsData(1, 2));

outputFile = strcat('Cluster annotation, session ',...
    sprintf('%03d', sessionId), ', start: ', dateTimeStart);

% initiate annotation GUI 
mainFigId = figure(...
    'Name',outputFile,...
    'NumberTitle','off', ...
    'units','normalized',...
    'outerposition',[0 0.05 1 0.90], ...
    'DeleteFcn', {@exitTool});

% LAYOUT (organized in a 5x7 matrix containing subplots):

% ind     name                subplot(5, 7, ...)
% 1 - session trajectory        [1:2 8:9 15:16]
% 2 - cluster trajectory        [3:4 10:11 17:18]
% 3 - velocity and acceleration 22:26
% 4 - instantanious speed       29:33
% 5 - accelerometer data        5:7
% 6 - features                  [27:28 34:35]
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

% for each cluster:
%   find the data and features
%   plot the trajectory, data and features
%   ask for user input (behaviour-class)

while i <= amountOfClusters
    clf %clearfigure

    % stop if the tool was closed before all clusters were annotated
    if ~run
        return
    end
    
    % get cluster features and data
    clusterTime = Clusters(i, :);
    [ClusterFeatures ClusterData] = ...
        createClusterFeatures(clusterTime, SessionGpsData, SessionAccData);
    
    % add the position in session and the previous class
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
    
    % initialize buttons
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

        % create figure with a plot of the session and write it to file
        tempfig = figure();
        hold on
        
        plotTrajectory(SessionCoordinates, ClusterCoordinates, true);
        
        if size(annotatedTrajectory, 1) > 1
            annotatedTrajectories(annotatedTrajectory, classColors);
        end
        
        title('Session trajectory');
        hold off
        
        print(tempfig, '-djpeg', strcat(outputPath, '/device_', deviceId, '_session_', ...
            sprintf('%03d', sessionId), '_sessionMap.jpeg'))
        close(tempfig)
        
        % checks if the tool was closed before end of session
        if exitBeforeEnd
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
        
        % adds cluster XY with class to annotatedTrajectory
        clusterPoints = size(ClusterCoordinates, 1);
        temp = zeros(clusterPoints, 4);
        temp(1:clusterPoints, 1) = ClusterFeatures(1);
        temp(:, 2:3) = ClusterCoordinates;
        temp(1:clusterPoints, 4) = behaviour;
        annotatedTrajectory = [annotatedTrajectory;temp];

        uiresume;
        
        % checks if this was last cluster in session
        if i == amountOfClusters
            exitBeforeEnd = false;
        end
        
        i = i + 1;
    end

end

