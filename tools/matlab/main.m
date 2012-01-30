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

    [newTime, newSpeed] = interpolate(Input(:, 1), Speed, timestampStep, 'pchip');
   
    [m1Course, m2Course, m3Course, timestamps] = histogramCompare(newTime, newSpeed, histogramSizeSeconds, timestampStep);

    timestamps = (timestamps - timestamps(1)) ./ 60;
  
    % m1 flying red
    % m2 diving green
    % m3 chillin blue
    plot(timestamps, m1Course, '-s', ...
                'LineWidth',1, ...
                'color','r', ...
                'MarkerSize',4); 
    hold on;
    plot(timestamps, m2Course, '-s', ...
                'LineWidth',1, ...
                'color','g', ...
                'MarkerSize',4); 

    plot(timestamps, m3Course, '-s', ...
                'LineWidth',1, ...
                'color','b', ...
                'MarkerSize',4); 


    %Clusters = findClusters(time, Derivative, peakThres);

    % plot all the clusters
    subplot(3,1,2);
    plotSecondDerivative2('acceleration and clusters', newSpeed, newTime);

%    % group sequences of small clusters into bigger ones
%    Clusters = awesomizeClusters(Clusters, timeThres);
%    
%    % plot the new clusters
%    subplot(3,1,3);
%    plotSecondDerivative2('acceleration and grouped clusters', Derivative,...
%        time, [Clusters(:, 1); Clusters(:, 2)]);
