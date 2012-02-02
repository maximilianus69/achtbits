function HNormData = normalizeHeight( Data )
%NORMALIZE_HEIGHT Normalizes the height of the bird by flattening outliers
%
% Arugments:
%   - Data: Nx8 matrix with a bird session data (readgps format)
%
% Returns:
%   Session data in readgps format, with normalized height
%
% It checks which heights are larger than the average value plus 3 times
% the standard deviation, and flattens those areas.
% 
% TODO: 
%   use other data (accelerometer/speed/...) to check if the points are
%   really outliers; linear interpolation instead of flattening

h = Data(:,5); % height data
t = Data(:,2); % time data

% TODO: remove code below when not needed anymore
%hDiff = h(2:end) - h(1:end-1); % differences between heights
%tDiff = t(2:end) - t(1:end-1); % passed times between heights
%hDerv = hDiff ./ tDiff; % derivative of height to time

% find outliers
mu = mean(h);
sigma = std(h);
outliers = find(abs(h - mu) > 2*sigma);

% flatten outliers
for i = 1:length(outliers)
    if(outliers(i) > 1)
        h(outliers(i)) = h(outliers(i)-1);
    else
        h(outliers(i)) = h(outliers(i)+1);
    end
end

HNormData = [Data(:,1:4) h Data(:,6:end)];

% debug compare plots - used in report
%figure;plot(t,Data(:,5));hold on;plot(t,h,'r');

end

