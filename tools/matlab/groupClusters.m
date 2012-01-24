function AwesomeClusters = groupClusters(LameClusters, timeThreshold)
    % Function that checks the time of clusters
    % to find the `chaos' clusters.
    % Input: [startTime, stopTime; startTime2, stopTime2; ...], time thresold
    % Output: Same as input, but with fewer clusters.
    differenceThreshold = 50;
    numThreshold = 10;
    Diff = LameClusters(:, 2) - LameClusters(:, 1);
    DiffBool = Diff > timeThreshold;
    % Create structured clusters with only one column
    Clusters = LameClusters(:, 1);
    Clusters(size(Clusters, 1)) = LameClusters(size(LameClusters, 1), 2);
    
    % Initialize relevant loop values
    % Counter for output values
    j = 1;
    % Initialize first cluster beginning
    AwesomeClusters(1, 1) = Clusters(1);

    % Initialize the average distance between clusters
    averageDifference = 1000;
    % The number of averaged cluster differences
    num = 1;

    % array to loop through:
    array = (1:size(Clusters, 1)-1);

    % The loop where the awesomizing magic happens!
    for i = array
        % When we have a peak that is relatively far from the current peaks in the chaos cluster,
        % we should end this cluster.
        if(((Clusters(i+1) - Clusters(i)) > (averageDifference * differenceThreshold)) && num > numThreshold)
            % TODO: check if the first timestamp is too far away in regards to 
            % average and replace it with 2nd timestamp if necessary
            AwesomeClusters(j, 2) = Clusters(i);
            j = j + 1;
            AwesomeClusters(j, 1) = Clusters(i);
            AwesomeClusters(j, 2) = Clusters(i+1);
            j = j+1;
            AwesomeClusters(j, 1) = Clusters(i+1);
            % Reinitialize averageDifference and num
            averageDifference = 1000;
            num = 0;
        % In the case that the difference between two clusters is too small
        % The cluster should not end, the average should be adjusted.
        elseif(Clusters(i+1) - Clusters(i) < timeThreshold) 
            averageDifference = (num * averageDifference + Diff(i)) / (num + 1)
            num = num + 1
        % In the case that the difference between two clusters is big enough,
        % we should end the current cluster.
        elseif(Clusters(i+1) - Clusters(i) > timeThreshold)
            % TODO: Also check if the first timestamp is too far away in regards 
            % to average and replace it with 2nd timestamp if necessary
            % The current cluster ending
            AwesomeClusters(j, 2) = Clusters(i);
            j = j + 1;
            AwesomeClusters(j, 1) = Clusters(i);
            AwesomeClusters(j, 2) = Clusters(i+1);
            j = j+1;
            AwesomeClusters(j, 1) = Clusters(i+1);
            % Reinitialize averageDifference and num
            averageDifference = 1000;
            num = 0;
        end
    end
    AwesomeClusters(j, 2) = Clusters(size(Clusters, 1))
    % Remove too short clusters
    D = AwesomeClusters(:, 2) - AwesomeClusters(:, 1);
    DB = D > 900;
    % Don't delete the last cluster
    DB(size(DB, 1)) = 1;
    AwesomeClusters = AwesomeClusters .* [DB DB];
    AwesomeClusters(~any(AwesomeClusters,2),:) = [];


        
