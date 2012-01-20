function Data = getRelevantData( dataCSV )
% .csv file line beforehand:
% "device_info_serial","date_time","latitude","longitude","altitude","pressure","temperature","h_accuracy","v_accuracy","x_speed","y_speed","z_speed","gps_fixtime","location","userflag","satellites_used","positiondop","speed_accuracy"
 
% Note: this is actual camel case :P
%  dataCSV should be dataCsv;


%GETRELEVANTDATA Summary of this function goes here
%   Detailed explanation goes here

    % read the data from csv file
    AllData = csvread(dataCSV);
    
    % get relevant columns:
    % 1 - ID
    % 2 - time
    % 3-5 - x, y, z
    % 6-8 - speed(x, y, z)
    Data = zeros(size(AllData, 1), 8);
    Data(:, 1:5) = AllData(:, 1:5);
    Data(:, 6:8) = AllData(:, 10:12);
    
    % remove all rows with no GPS data
    Data(~any(Data,2),:) = [];
    
    % load the Northsea-area
    northsea = csvread('noordzeeCoordinates.txt');
    % make a binary matrix indicating points above Northsea
    inNorthSea = inpolygon(Data(:,3), Data(:,4), northsea(:,1), northsea(:,2));
    
    % use binary matrix as a mask to find all rows above Northsea
    for i = 1:size(Data, 2)
        Data(:,i) = inNorthSea .* Data(:,i);
    end 
    
end
%}
