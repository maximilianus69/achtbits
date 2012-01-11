function matrix = readgps(fileName)
    % Function that reads gps data from a csv file seperated by ;
    % The seventh and ninth column are now assumed to contain the gps data (x, y, z)
    % The second column contains a time stamp
    % Returns: A size(input(1), 4) by 4 matrix with time stamps and gps data
    A = dlmread(fileName, ";");
    matrix = ones(size(A)(1), 4);
    matrix(:, 1) = A(:, 2);
    % In case we have seperated values:
    matrix(:, 2:4) = A(:,3:5);
    northsea = dlmread("noordzeeCoordinates.txt",",");
    %inNorthSea = inpolygon(matrix(:,2), matrix(:,3), northsea(:,1), northsea(:,2));
    inNorthSea = ones(size(matrix)(1),1);
    for i = 1:size(matrix)(2)
        matrix(:,i) = inNorthSea .* matrix(:,i);
    end 








