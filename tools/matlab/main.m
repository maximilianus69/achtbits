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
    size(Der)
    size(Input)
    figure(1);
    subplot(2,1,1);
    plotSecondDerivative(Input(:, 3:5), Input(:, 2));
    subplot(2,1,2);
    plotSecondDerivative(Der(:, 3:5), Der(:, 2));
    peakThres = 2*10^(-5);
    Clusters = findClusters(Gps, peakThres);
    % 16 minutes = 960 000 ms
    %Clusters = awesomizeClusters(Clusters, 96000);


    out = Clusters .- Gps(1, 2);

    
