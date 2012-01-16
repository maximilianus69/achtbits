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
AccRight = Acc(:, 3:5)

for i = 1:size(AccRight, 1)
    Acc2(i, 1) = norm(AccRight(i, :));
end
% find index of peaks by comparing with the threshold
Peaks = Acc2 > peakThres
% Get the middle of the peak:
% TODO: WIthout loop?
beginPos = 0;
endPos = 0;
for j = 1:size(Peaks, 1)
    if Peaks(j) == 1 && beginPos == 0
        beginPos = j
    elseif Peaks(j) == 0 && beginPos ~= 0
        Peaks(beginPos+1:(j-1)) = 0
        % Let the 1-value be on the middle of the peak
        %Peaks(round((beginPos+(j-1))/2)) = 1;
        Peaks(j) = 1
        beginPos = 0
    end
end
        
        
        


        

PeakPos = find(Peaks);

% use indices to retrieve start-time and end-time of period
Clusters = [];
time = Data(:, 2);
for i = 1:(size(PeakPos, 1)-1)
    Clusters = [Clusters; time(i) time(i+1)];
end

