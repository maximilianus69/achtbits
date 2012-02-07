function SimpleClusters = simpleFindClusters(Classes, minClusterLength)
    % SIMPLEFINDCLUSTERS: Finds class changes.
    %
    % Input: Classes - a N by 2 array with time stamps and classifications
    %        minClusterLength - the minimum length of a cluster in seconds
    % Output: SimpleClusters - an N by 2 array of simple cluster time stamps
    currentClass = 0;
    % Start of the clusters is at start of the Classes matrix
    SimpleClusters(1, 1) = Classes(1, 1);
    j = 1;
    for i = 1:size(Classes, 1)
        if Classes(i, 2) ~= currentClass
            SimpleClusters(j, 2:3) = [Classes(i, 1) currentClass];
            j = j + 1;
            SimpleClusters(j, 1) = Classes(i, 1);
            currentClass = Classes(i, 2);
        end
    end
    SimpleClusters(end, 2:3) = [Classes(end, 1) currentClass];

    D = SimpleClusters(:, 2) - SimpleClusters(:, 1);
    % A cluster should be 10 minutes minimum
    DB = D > minClusterLength;
    SimpleClusters = SimpleClusters .* [DB DB DB];
    % Delete the short clusters
    SimpleClusters(~any(SimpleClusters,2),:) = [];
    % Return start and end of the session, if there are no clusters. This prevents errors.
    if(isempty(SimpleClusters))
        SimpleClusters = [Classes(1, 1), Classes(end, 1)];
    end
