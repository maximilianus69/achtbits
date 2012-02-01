function Class = main(deviceId, sessionId)

    % Wrapper for reading gps coordinates from a csv file, taking the ones above
    % the north sea, and calculating vectors with the direction and speed
    % It uses readgps and makeVectors


    histogramSizeSeconds = 900;
    timestampStep = 50;
    % Initialize the half of the window. In the loop we will look back and forth by this size
    halfWindowSize = 5;

    addpath('plot');
    Gps = readgps(deviceId, sessionId);
    Input = getTimeAndSpeed(Gps);
    InstSpeed = Gps(:, 9:10);
    Time = Input(:, 1);
    Time = (Time - Time(1)) ./60;
    
    % plot the speed
    fig = figure('Name', strcat('device:  ', deviceId, ', session ID:  ', int2str(sessionId)));
    set(fig,'units','normalized','outerposition',[0 0 1 1]);
    
    
    % Calculate the current speed from x_speed and y_speed
    for i = 1:size(Input, 1)
        Speed(i, :) = norm(Input(i, 2:3));
    end
    subplot(3,1,1);
    % plotSecondDerivative('velocity', Input(:, 2:3), Input(:, 1));
    plotSecondDerivative2('velocity', Speed, Input(:,1));
    hold on
    plot(Time, abs(InstSpeed(:, 1)), 'color', 'r'); 
    plot(Time, abs(InstSpeed(:, 2)), 'color', 'b'); 
    hold off

    subplot(3, 1, 2);
    % Get interpolated values
    [NewTime, NewSpeed] = interpolate(Input(:, 1), Speed, timestampStep, 'pchip');
    [NewXTime, NewXSpeed] = interpolate(Input(:, 1), abs(InstSpeed(:, 1)), timestampStep, 'pchip');
    [NewYTime, NewYSpeed] = interpolate(Input(:, 1), abs(InstSpeed(:, 2)), timestampStep, 'pchip');

    plotSecondDerivative('Interpolated', NewSpeed, NewTime);
    hold on
    plot((NewXTime- NewXTime(1))./60, NewXSpeed, 'color', 'r');
    plot((NewYTime- NewYTime(1))./60, NewYSpeed, 'color', 'b');
    hold off
   
    [m1Course, m2Course, m3Course, timestamps] = histogramCompare(NewTime, NewSpeed,NewXSpeed, NewYSpeed, histogramSizeSeconds, timestampStep);

    PlotTimestamps = (timestamps - timestamps(1) + histogramSizeSeconds/2) ./ 60;
    
    subplot(3, 1, 3);
    % To plot the right width
    NewTime = (NewTime - NewTime(1)) ./ 60;
    plot(NewTime, NewSpeed, 'color', 'w'); 
    hold on
    % Plot the actual values
    plotHists(m1Course, m2Course, m3Course, PlotTimestamps);
        
    [Max Index] = max([m1Course m2Course m3Course]');
    % Class will be a N by 1 vector containing the classes
    Class = [];
    Class(:, 1)= timestamps(1:size(timestamps, 1)-2*halfWindowSize) + timestampStep * halfWindowSize;

    for i = halfWindowSize + 1:size(Index, 2) - halfWindowSize
        % We could use a gaussian blur, that would work like this: 
        % For now it is outcommented, because we didn't see any differences
        %gauss = fspecial('gaussian', [1, (2*halfWindowSize+1)], 1);
        %class = round(halfWindowSize*gauss .* Index(i-halfWindowSize:i+halfWindowSize));
        %Class(i-halfWindowSize-1, 2) = class(halfWindowSize + 1);

        Class(i-halfWindowSize, 2) = mode(Index(i-halfWindowSize:i+halfWindowSize));
    end

    Clusters = simpleFindClusters(Class, 900);

    subplot(3, 1, 2);
    hold on
    PlotClusters = (Clusters - Input(1, 1))./60;
    for p = 1:length(Clusters(:, 1))
        line([PlotClusters(p, 1), PlotClusters(p, 1)], [0 max(Speed)], 'Color', 'r');
        line([PlotClusters(p, 2), PlotClusters(p, 2)], [0 max(Speed)], 'Color', 'c');
    end
    hold off

    Clusters = interpolatedToRealTimestamp(Clusters, Input(:, 1));
    subplot(3, 1, 1);

    % for plotting purposes:
    Clusters = (Clusters - Input(1, 1))./60;
    hold on 

    
    for p = 1:size(Clusters, 1)
        line([Clusters(p, 1), Clusters(p, 1)], [0 max(Speed)], 'Color', 'r');
        line([Clusters(p, 2), Clusters(p, 2)], [0 max(Speed)], 'Color', 'c');
    end


    hold off
