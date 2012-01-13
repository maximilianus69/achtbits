function out = derivative(coordinates)
    % Function that creates vectors from gps coordinates and time stamps
    % Input: n*4 matrix with : [ID time_stamp x y z]
    % Output: Matrix with 3d vectors [vec1 ; vec2 ; ...; vec_n]
    % The length of the vectors represent the speed, the direction represents the
    % change of direction 
    place1 = coordinates(1:size(coordinates, 1)-1, 3:5);
    place2 = coordinates(2:size(coordinates, 1), 3:5);
    time1 = coordinates(1:size(coordinates, 1)-1, 2);
    time2 = coordinates(2:size(coordinates, 1), 2);
    out(:,1:2) = coordinates(:,1:2);
    out(size(out, 1), :) = [];
    for i = 1:size(place1, 2)
        out(:,i+2) = (place1(:,i) - place2(:,i)) ./ ((time2 - time1));
    end 
