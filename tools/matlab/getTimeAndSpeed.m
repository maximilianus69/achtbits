function TimeAndSpeed = getTimeAndSpeed( Data )
%getTimeAndSpeed creates a Nx3 with time and xy speed
%   Input:
%   [device_info_serial date_time latitude longitude altitude vnorth veast 
%   vdown]
%
%   Output:
%   [time vnorth veast]

TimeAndSpeed = [Data(:, 2) Data(:, 6:7)];

end

