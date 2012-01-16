function Clusters = findClusters(Time, Derivative, peakThres)
    % Accepts a derivative with time stamps in the first column
    %Normals = ones(size(Derivative, 1), 1);
        
    % Create length by 1 array of normals
    for i = 1:size(Derivative, 1)
        Normals(i, 1) = norm(Derivative(i, :));
    end
    
    Peaks = Normals > peakThres;
    NewPeaks = ones(size(Peaks));

    for i = 1:(size(Peaks, 1)-1)
        if(Peaks(i) == 1 && Peaks(i+1) == 0)
            NewPeaks(i) = 1;
        elseif(Peaks(i) == 0 && Peaks(i+1))
            NewPeaks(i) = 1;
        else
            NewPeaks(i) = 0;
        end
    end

PeakPos = find(NewPeaks);
Clusters = [];
for i = 1:(size(PeakPos, 1)-1)
    Clusters = [Clusters; Time(PeakPos(i)) Time(PeakPos(i+1))];
end


