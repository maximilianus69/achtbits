function AwesomeClusters = awesomizeClusters(LameClusters, timeThreshold)
    % Function that checks the time of clusters
    % to find the `chaos' clusters.
    % Input: [startTime, stopTime; startTime2, stopTime2; ...], time thresold
    % Output: Same as input, but with fewer clusters.
    Diff = LameClusters(:, 2) - LameClusters(:, 1)
    DiffBool = Diff > timeThreshold
    j = 1;
    AwesomeClusters(1, 1) = LameClusters(1, 1);
    array = (1:size(Diff, 1)-1);
    for i = array
        % if we have a too short cluster:
        % The difference boolean = 1 and the previous is = 0
        if (DiffBool(i) && ~DiffBool(i+1))
            %Set current begin time for this cluster
            AwesomeClusters(j, 2) = LameClusters(i, 2);
            j = j+1;
            AwesomeClusters(j, 1) = LameClusters(i, 2);
        %if this cluster ends
        elseif (~DiffBool(i) && DiffBool(i+1))
            % Add the cluster end
            AwesomeClusters(j, 2) = LameClusters(i, 2);
            j = j + 1;
            % Add the cluster between the chaos clusters
            AwesomeClusters(j, 1) = LameClusters(i, 2);
            AwesomeClusters(j, 2) = LameClusters(i+1, 2);
            j = j+1;
            % Add the new cluster beginning
            AwesomeClusters(j, 1) = LameClusters(i+1, 2);
            if(i < size(array, 2))
                array(i+1) = [];
            end
        end
    end
    AwesomeClusters(size(AwesomeClusters, 1), 2) = LameClusters(size(LameClusters, 1), 2);
    D = AwesomeClusters(:, 2) - AwesomeClusters(:, 1);
    DB = D > 0;
    AwesomeClusters = AwesomeClusters .* [DB DB];
    AwesomeClusters(~any(AwesomeClusters,2),:) = [];
