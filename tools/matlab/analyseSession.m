function Clusters = analyseSession( SessionData )
    %ANALYSESESSION Finds the clusters in a session 
    %   calculates the acceleration and uses this to determine cluster
    %   start/end
    %   output:
    %   Clusters = nx2 matrix with start/end times 
    %   [begin_t1 begin_t1; ... ; begin_tn begin_tn]

    % *** maybe add more session analysis?***

    histogramSizeSeconds = 900;
    timestampStep = 50;
    % Initialize the half of the window. In the loop we will look back and forth by this size
    halfWindowSize = 4;
    
    % Get the time and instantaneous speed
    Time = SessionData(:, 2);
    InstSpeed = SessionData(:, 9:10);

    % Calculate the speed
    for i = 1:size(SessionData, 1)
        Speed(i, :) = norm(SessionData(i, 6:7));
    end
    % Get interpolated values
    [NewTime, NewSpeed] = interpolate(SessionData(:, 2), Speed, timestampStep, 'linear');
    [NewXTime, NewXSpeed] = interpolate(SessionData(:, 2), abs(InstSpeed(:, 1)), timestampStep, 'pchip');
    [NewYTime, NewYSpeed] = interpolate(SessionData(:, 2), abs(InstSpeed(:, 2)), timestampStep, 'pchip');
 
    % Get the histogram awesomeness values
    [m1Course, m2Course, m3Course, timestamps] = histogramCompare(NewTime, NewSpeed,NewXSpeed, NewYSpeed, histogramSizeSeconds, timestampStep);
    
    % Find the max values for which behavior is done. This defines clusters
    [Max Index] = max([m1Course m2Course m3Course]');
    % Class will be a N by 1 vector containing the classes
    Class = [];
    Class(:, 1)= timestamps(1:size(timestamps, 1)-2*halfWindowSize) + timestampStep*halfWindowSize;

    % Smooth the clusters.
    for i = halfWindowSize + 1:size(Index, 2) - halfWindowSize
        % We could use a gaussian blur, in which case we could use this code:
        % For now it is outcommented, because we didn't see any differences
        % gauss = fspecial('gaussian', [1, (2*halfWindowSize+1)], 1);
        % class = round(halfWindowSize*gauss .* Index(i-halfWindowSize:i+halfWindowSize));
        % Class(i-halfWindowSize-1, 2) = class(halfWindowSize + 1);

        Class(i-halfWindowSize, 2) = mode(Index(i-halfWindowSize:i+halfWindowSize));
    end
    
    % find the cluster edges
    Clusters = simpleFindClusters(Class, 900);
    Clusters(:,1:2) = interpolatedToRealTimestamp(Clusters(:, 1:2), SessionData(:, 2));
