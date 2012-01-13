function Clusters = findClusters( Data, peakThres, timeThres)
%FINDCLUSTERS Finds the sart and end point of a behaviour period
%   Detailed explanation goes here

% find the acceleration
Acc = derivative(Data(:,2:5));

% get length of acceleration vectors
Acc = sqrt(sum(Acc^2, 2));

% find index of peaks by comparing with the threshold
Peaks = Acc > peakThres;
PeakPos = find(Peaks);

% use indices to retrieve start-time and end-time of period
Clusters = []
time = Data(:, 2);
for i = 1:size(PeakPos, 1)
    if i+1 <= size(PeakPos, 1)
        Clusters = [Clusters; time(i) time(i+1)]
    end
end

end

