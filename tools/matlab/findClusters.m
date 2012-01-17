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
    for i = 1:size(Derivative, 1)
        Normals(i, 1) = norm(Derivative(i, :));
    end
    
    Peaks = Normals > peakThres;
    NewPeaks = ones(size(Peaks));
    NextI = 0;

    for i = 1:(size(Peaks, 1)-1)
        if(Peaks(i) == 1 && Peaks(i+1) == 0)
            % IF there is a slowdown, the next i should be 1 (going from 1 to 0):
            NextI = 1;
        elseif(~Peaks(i) && Peaks(i+1))
            % If we go from - to 1:
            NewPeaks(i) = 1;
        elseif(NextI)
            NewPeaks(i) = 1;
            NextI = 0;
        else
            NewPeaks(i) = 0;
        end
    end

PeakPos = find(NewPeaks);
Clusters = [Time(1), Time(PeakPos(1))];
for i = 1:(size(PeakPos, 1)-1)
    Clusters = [Clusters; Time(PeakPos(i)) Time(PeakPos(i+1))];
end


