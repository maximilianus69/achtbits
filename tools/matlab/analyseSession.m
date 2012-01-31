function Clusters = analyseSession( SessionData )
    %ANALYSESESSION Finds the clusters in a session 
    %   calculates the acceleration and uses this to determine cluster
    %   start/end
    %   output:
    %   Clusters = nx2 matrix with start/end times 
    %   [begin_t1 begin_t1; ... ; begin_tn begin_tn]

    % *** maybe add more session analysis?***

    histogramSizeSeconds = 900;
    timestampStep = 100;
    % Initialize the half of the window. In the loop we will look back and forth by this size
    halfWindowSize = 2;
    
    % Get the time and instantaneous speed
    Time = SessionData(:, 2);
    InstSpeed = SessionData(:, 9:10);

    % Calculate the speed
    for i = 1:size(SessionData, 1)
        Speed(i, :) = norm(SessionData(i, 2:3));
    end
 
    % Get interpolated values
    [NewTime, NewSpeed] = interpolate(SessionData(:, 2), Speed, timestampStep, 'pchip');
    [NewXTime, NewXSpeed] = interpolate(SessionData(:, 2), abs(InstSpeed(:, 1)), timestampStep, 'pchip');
    [NewYTime, NewYSpeed] = interpolate(SessionData(:, 2), abs(InstSpeed(:, 2)), timestampStep, 'pchip');
 
    % Get the histogram awesomeness values
    [m1Course, m2Course, m3Course, timestamps] = histogramCompare(NewTime, NewSpeed,NewXSpeed, NewYSpeed, histogramSizeSeconds, timestampStep);
    
    % Find the max values for which behavior is done. This defines clusters
    [Max Index] = max([m1Course m2Course m3Course]');
    % Class will be a N by 1 vector containing the classes
    Class = [];
    Class(:, 1)= timestamps(halfWindowSize:size(timestamps, 1)-halfWindowSize- 1) + histogramSizeSeconds/2; 

    % Smooth the clusters.
    for i = halfWindowSize + 1:size(Index, 2) - halfWindowSize
        Class(i-halfWindowSize, 2) = mode(Index(i-halfWindowSize:i+halfWindowSize));
    end
    
    % find the cluster edges
    Clusters = simpleFindClusters(Class, 1200);
    Clusters = interpolatedToRealTimestamp(Clusters, SessionData(:, 2));
