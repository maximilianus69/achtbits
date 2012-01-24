function AwesomeClusters = awesomizeClusters(LameClusters, timeThreshold)
    % Function that checks the time of clusters
    % to find the `chaos' clusters.
    % Input: [startTime, stopTime; startTime2, stopTime2; ...], time thresold
    % Output: Same as input, but with fewer clusters.
    differenceThreshold = 25;
    Diff = LameClusters(:, 2) - LameClusters(:, 1);
    DiffBool = Diff > timeThreshold;
    j = 1;
    AwesomeClusters(1, 1) = LameClusters(1, 1);
    array = (1:size(Diff, 1)-1);
    % Initialize the average distance between clusters
    averageDifference = 1000;
    num = 1;
    for i = array
        % if we have a too short cluster:
        % The difference boolean = 1 and the previous is = 0
        if (DiffBool(i) && ~DiffBool(i+1))
            % End of previous cluster
            AwesomeClusters(j, 2) = LameClusters(i, 2);
            % Set current begin time for this cluster
            j = j+1;
            AwesomeClusters(j, 1) = LameClusters(i, 2);
        %if this cluster ends
        elseif ((~DiffBool(i) && DiffBool(i+1)) || ((Diff(i) > differenceThreshold * averageDifference) && num > 5))
            % Add the cluster end
            AwesomeClusters(j, 2) = LameClusters(i, 2);
            j = j + 1;
            % Add the cluster between the chaos clusters
            AwesomeClusters(j, 1) = LameClusters(i, 2);
            AwesomeClusters(j, 2) = LameClusters(i+1, 2);
            j = j+1;
            % Add the new cluster beginning
            AwesomeClusters(j, 1) = LameClusters(i+1, 2);
            % Remove the next data point, because we have been working with i+1, 
            % which would be overwritten otherwise.
            if(i < size(array, 2))
                array(i+1) = [];
            end
            % Reinitialize average distance between clusters:
            averageDifference = 0
            num = 1;
        % The cluster goes on:
        else
            averageDifference = (num * averageDifference + Diff(i)) / (num + 1)
            num = num + 1;
        end
    end
    % Add the end
    AwesomeClusters(size(AwesomeClusters, 1), 2) = LameClusters(size(LameClusters, 1), 2);
    % Remove too short clusters
    D = AwesomeClusters(:, 2) - AwesomeClusters(:, 1);
    DB = D > 900;
    % Don't delete the last cluster
    DB(size(DB, 1)) = 1;
    AwesomeClusters = AwesomeClusters .* [DB DB];
    AwesomeClusters(~any(AwesomeClusters,2),:) = [];




% We krijgen een lijst met timestamps binnen, met op elke timestamp een peak. 
% We loopen door deze lijst heen:
% - nemen de timestamp als beginpunt van een cluster
% - elke opvolgende timestamp halen we weg als die 
%       * minder dan X seconden ver weg is EN 
%       * de afstand tussen de afgelopen timestamp en de opvolgende timestamp
%       minder is dan Y maal de gemiddelde afstand tussen de timestamps die 
%       al weggehaald zijn.
%  en we onthouden het aantal secondes tussen deze clusters. 
% - we nemen een timestamp als eind van een cluster als deze niet aan de 
% bovenstaande eisen voldoet. (de eerstvolgende timestamp word weer een 
% begin van een cluster). 


