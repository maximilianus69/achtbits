function Clusters = findClusters(Time, Derivative, peakThres)
%FINDCLUSTERS Finds the start and end point of a behaviour period
%   Input:
%   Time = data array of the timestamps
%   Derivative = Data array with several derivative values, should be as long as Time
%   peakThres = threshold for recognising peaks
%   
%   output:
%   Clusters = nx2 matrix with start/end times 
%   [begin_t1 begin_t1; ... ; begin_tn begin_tn]
%
%   use the data to calulate acceleration
%   find big chances in acceleration with threshold
%   use these points to determine start and end time of a period
        
    % Create length by 1 array of normals
    UpPeaks = Derivative > peakThres
    DownPeaks = (Derivative < (-peakThres));
    NewPeaks = zeros(size(UpPeaks));
    NextI = 0;

    for i = 1:(size(UpPeaks, 1)-1)
        if(NextI)
            NewPeaks(i,:) = 1;
            NextI = 0;
        end
        % If we speed up, this i should be 1
        if(UpPeaks(i))
            NextI = 1;
        % IF there is a slowdown, the next i should be 1 (going from 1 to 0):
        elseif(DownPeaks(i))
            NewPeaks(i, :) = 1;
        end
    end

PeakPos = find(NewPeaks);
Clusters = [];
size(Time)
if(~isempty(PeakPos))
    Clusters = [Time(1), Time(PeakPos(1))];
    for i = 1:(size(PeakPos, 1)-1)
        Clusters = [Clusters; Time(PeakPos(i)) Time(PeakPos(i+1))];
    end
    % This puts the very last point as the last in the cluster
    Clusters = [Clusters; Time(PeakPos(size(PeakPos, 1))) Time(size(Time, 1))];
else
    Clusters = [Time(1), Time(size(Time, 1))];
end



