function out = main(fileName)
    % Wrapper for reading gps coordinates from a csv file, taking the ones above
    % the north sea, and calculating vectors with the direction and speed
    % It uses readgps and makeVectors
    addpath('plot');
    Gps = readgps(fileName);
    Input = getTimeAndSpeed(Gps);
    Der = derivative(Input);
    
    % split Der in time and derivative
    time = Der(:, 1);
    Derivative = Der(:, 2:3);

    % Threshold based on different time stamps
    %peakThres = 2*10^(-5);
    peakThres = 0.01;
    Clusters = findClusters(time, Derivative, peakThres);
    Clusters = awesomizeClusters(Clusters, 1500);
    
    figure(1);
    subplot(2,1,1);
    plotSecondDerivative(Input(:, 2:3), Input(:, 1));
    
    subplot(2,1,2);
    plotSecondDerivative(Derivative, time, [Clusters(:, 1); Clusters(:, 2)]);
    
    out = Clusters;
