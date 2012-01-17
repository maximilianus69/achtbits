function out = main(fileName)
    % Wrapper for reading gps coordinates from a csv file, taking the ones above
    % the north sea, and calculating vectors with the direction and speed
    % It uses readgps and makeVectors
    addpath('plot');
    Gps = readgps(fileName);
    Input = getTimeAndSpeed(Gps);
    
    % plot the speed
    figure(1);
    subplot(3,1,1);
    plotSecondDerivative('velocity', Input(:, 2:3), Input(:, 1));
    
    Der = derivative(Input);
    
    % split Der in time and derivative
    time = Der(:, 1);
    Derivative = Der(:, 2:3);

    % Threshold based on different time stamps
    %peakThres = 2*10^(-5);
    peakThres = 0.01;
    Clusters = findClusters(time, Derivative, peakThres);

    % plot all the clusters
    subplot(3,1,2);
    plotSecondDerivative('acceleration and clusters', Derivative, time,...
        [Clusters(:, 1); Clusters(:, 2)]);

    % group sequences of small clusters into bigger ones
    Clusters = awesomizeClusters(Clusters, 2000);
    
    % plot the new clusters
    subplot(3,1,3);
    plotSecondDerivative('acceleration and grouped clusters', Derivative,...
        time, [Clusters(:, 1); Clusters(:, 2)]);
    
    out = Clusters;
