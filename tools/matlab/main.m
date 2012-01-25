function [Gps Clusters] = main(deviceId, sessionId)
    % Wrapper for reading gps coordinates from a csv file, taking the ones above
    % the north sea, and calculating vectors with the direction and speed
    % It uses readgps and makeVectors

    % Threshold based on different time stamps, used for findClusters, determines
    % what datapoints becomes peaks?
    %peakThres = 2*10^(-5);
    peakThres = 5;

    % Threshold used for awesomizeClusters, determines peaks in a range become one? 
    timeThres = 1200;

    addpath('plot');
    Gps = readgps(deviceId, sessionId);
    Input = getTimeAndSpeed(Gps);
    
    % plot the speed
    fig = figure(1);
    %set(fig,'units','normalized','outerposition',[0 0 1 1]);

    subplot(3,1,1);
    plotSecondDerivative('velocity', Input(:, 2:3), Input(:, 1));
    
    Der = derivative(Input);
    % split Der in time and derivative
    time = Der(:, 1);
    Derivative = Der(:, 2);

    Clusters = findClusters(time, Derivative, peakThres);

    % plot all the clusters
    subplot(3,1,2);
    plotSecondDerivative('acceleration and clusters', Derivative, time,...
        [Clusters(:, 1); Clusters(:, 2)]);

    % group sequences of small clusters into bigger ones
    Clusters = awesomizeClusters(Clusters, timeThres);
    
    % plot the new clusters
    subplot(3,1,3);
    plotSecondDerivative('acceleration and grouped clusters', Derivative,...
        time, [Clusters(:, 1); Clusters(:, 2)]);
