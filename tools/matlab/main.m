function [Gps Clusters] = main(deviceId, sessionId)
    % Wrapper for reading gps coordinates from a csv file, taking the ones above
    % the north sea, and calculating vectors with the direction and speed
    % It uses readgps and makeVectors


    histogramSizeSeconds = 900;
    timestampStep = 150;

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


    
    %Der = derivative(Input);
    % split Der in time and derivative
    %time = Der(:, 1);
    %Derivative = Der(:, 2);


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

    timestamps = (timestamps - timestamps(1) + histogramSizeSeconds/2) ./ 60;
    
    subplot(3, 1, 3);
    % To plot the right width
    NewTime = (NewTime - NewTime(1)) ./ 60;
    plot(NewTime, NewSpeed, 'color', 'w'); 
    hold on
    % Plot the actual values
    plotHists(m1Course, m2Course, m3Course, timestamps);
    hold off

