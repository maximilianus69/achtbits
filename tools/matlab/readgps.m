function Matrix = readgps(fileName)
    % Function that reads gps data from a csv file seperated by ;
    % The seventh and ninth column are now assumed to contain the gps data (x, y, z)
    % The second column contains a time stamp
    % Returns: A size(input(1), 4) by 4 matrix with time stamps and gps data
    % "device_info_serial","date_time","latitude","longitude","altitude","pressure","temperature","h_accuracy","v_accuracy","x_speed","y_speed","z_speed","gps_fixtime","location","userflag","satellites_used","positiondop","speed_accuracy"
    Data = dlmread(fileName, ',');
    Matrix = ones(size(Data, 1), 8);
    % The bird ID
    Matrix(:, 1) = Data(:, 1);
    % The time stamp
    Matrix(:, 2) = Data(:, 2);
    % In case we have seperated values:
    % The x, y and z position
    Matrix(:, 3:5) = Data(:,3:5);
    % The x_speed, y_speed, z_speed
    Matrix(:, 6:8) = Data(:, 6:8);
    % Deprecated check: This is done in the preprocessing java script.
    northsea = dlmread('noordzeeCoordinates.txt',',');
    inNorthSea = inpolygon(Matrix(:,3), Matrix(:,4), northsea(:,1), northsea(:,2));
    sum(inNorthSea)
    %inNorthSea = ones(size(Matrix, 1),1);
    %remove zero values:
    %Matrix(~any(Matrix,2),:) = [];

    %for i = 1:size(Matrix, 2)
    %    Matrix(:,i) = inNorthSea .* Matrix(:,i);
    %end 
    %Matrix(~any(Matrix,2),:) = [];

