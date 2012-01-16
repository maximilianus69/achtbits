function out = main(fileName)
    % Wrapper for reading gps coordinates from a csv file, taking the ones above
    % the north sea, and calculating vectors with the direction and speed
    % It uses readgps and makeVectors
    addpath('plot');
    Gps = readgps(fileName);
    Input = ones(size(Gps, 1), 5);
    % ID and Timestamp
    Input(:, 1:2) = Gps(:, 1:2);
    % X_speed, Y_speed and Z_speed
    Input(:, 3:5) = Gps(:, 6:8);
    Der = derivative(Input);
    
    % Threshold based on different time stamps
    %peakThres = 2*10^(-5);
    peakThres = 0.01;
    % Clusters = findClusters(Gps, peakThres)
    Clusters = findClustersNew(Gps(:, 2), Der(:, 3:5), peakThres)
    
    figure(1);
    subplot(2,1,1);
    plotSecondDerivative(Input(:, 3:5), Input(:, 2));
    subplot(2,1,2);
    % 16 minutes = 960 000 ms
    Clusters = awesomizeClusters(Clusters, 500);
    plotSecondDerivative(Der(:, 3:5), Der(:, 2), [Clusters(:,1); Clusters(:,2)]);
    out = Clusters;

    
