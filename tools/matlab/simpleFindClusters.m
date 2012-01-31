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
            SimpleClusters(j, 2) = Classes(i, 1);
            j = j + 1;
            SimpleClusters(j, 1) = Classes(i, 1);
            currentClass = Classes(i, 2);
        end
    end
    SimpleClusters(size(SimpleClusters, 1), 2) = Classes(size(Classes, 1), 1)

    D = SimpleClusters(:, 2) - SimpleClusters(:, 1);
    % A cluster should be 10 minutes minimum
    DB = D > minClusterLength;
    % Don't delete the first and last cluster
    if(~isempty(DB))
        if(SimpleClusters(1, 1) ~= SimpleClusters(1, 2))
            DB(1) = 1;
        end
        DB(size(DB, 1)) = 1;
    end
    SimpleClusters = SimpleClusters .* [DB DB];
    SimpleClusters(~any(SimpleClusters,2),:) = [];
