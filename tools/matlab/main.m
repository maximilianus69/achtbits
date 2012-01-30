function [Gps Clusters] = main(deviceId, sessionId)
    % Wrapper for reading gps coordinates from a csv file, taking the ones above
    % the north sea, and calculating vectors with the direction and speed
    % It uses readgps and makeVectors


    histogramSizeSeconds = 900;
    timestampStep = 150;

    % Threshold based on different time stamps, used for findClusters, determines
    % what datapoints becomes peaks?
    %peakThres = 2*10^(-5);
    peakThres = 7;

    % Threshold used for awesomizeClusters, determines peaks in a range become one? 
    timeThres = 1500;

    addpath('plot');
    Gps = readgps(deviceId, sessionId);
    Input = getTimeAndSpeed(Gps);
    
    % plot the speed
    fig = figure(1);
    %set(fig,'units','normalized','outerposition',[0 0 1 1]);
    
    
    % Calculate the current speed from x_speed and y_speed
    for i = 1:size(Input, 1)
        Speed(i, :) = norm(Input(i, 2:3));
    end
    subplot(3,1,1);
    % plotSecondDerivative('velocity', Input(:, 2:3), Input(:, 1));
    plotSecondDerivative2('velocity', Speed, Input(:,1));
    
    %Der = derivative(Input);
    % split Der in time and derivative
    %time = Der(:, 1);
    %Derivative = Der(:, 2);

    [NewTime, NewSpeed] = interpolate(Input(:, 1), Speed, timestampStep, 'pchip');

    subplot(3, 1, 2);
    plotSecondDerivative('Interpolated', NewSpeed, NewTime);
   
    [m1Course, m2Course, m3Course, timestamps] = histogramCompare(NewTime, NewSpeed, histogramSizeSeconds, timestampStep);

    timestamps = (timestamps - timestamps(1) + histogramSizeSeconds/2) ./ 60;
    
    subplot(3, 1, 3);
    plotHists(m1Course, m2Course, m3Course, timestamps);

