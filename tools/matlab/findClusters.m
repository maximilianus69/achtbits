function Clusters = findClusters( Data, peakThres)
%FINDCLUSTERS Finds the start and end point of a behaviour period
%   Input:
%   Data = ID, time, x, y, z, speed_x, speed_y, speed_z
%   peakThres = threshold for recognising peaks
%   
%   output:
%   Clusters = nx2 matrix with start/end times 
%   [begin_t1 begin_t1; ... ; begin_tn begin_tn]
%
%   use the data to calulate acceleration
%   find big chances in acceleration with threshold
%   use these points to determine start and end time of a period

% find the acceleration
DataPrep = [Data(:, 1:2) Data(:, 6:8)];
Acc = derivative(DataPrep);

% get length of acceleration vectors
AccSqared = Acc(:, 3:5).^2;
Acc = sqrt(sum(AccSqared, 2));

% find index of peaks by comparing with the threshold
Peaks = Acc > peakThres;
PeakPos = find(Peaks);

% use indices to retrieve start-time and end-time of period
Clusters = [];
time = Data(:, 2);
for i = 1:size(PeakPos, 1)
    if i+1 <= size(PeakPos, 1)
        Clusters = [Clusters; time(i) time(i+1)];
end

end

