function out = main(fileName)
    % Wrapper for reading gps coordinates from a csv file, taking the ones above
    % the north sea, and calculating vectors with the direction and speed
    % It uses readgps and makeVectors
    Gps = readgps(fileName);
    input = ones(size(Gps, 1), 5);
    % ID and Timestamp
    input(:, 1:2) = Gps(:, 1:2);
    % X_speed, Y_speed and Z_speed
    input(:, 3:5) = Gps(:, 6:8);
    Der = derivative(Gps); 
    out = makeVectors(gps);

    
