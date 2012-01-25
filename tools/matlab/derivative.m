function out = derivative(coordinates)
    % Function that creates vectors from gps coordinates and time stamps
    % Input: n*3 matrix with : [time_stamp velocityNorth velocityEast]
    % Output: Matrix with 3d vectors [vec1 ; vec2 ; ...; vec_n]
    % The length of the vectors represent the speed, the direction represents the
    % change of direction     
    
    % TODO: This now uses the speed in two directions. Shouldn't we look at the 
    % absolute speed difference? (As in: the difference in the x-y-speed, not the difference
    % in the x-speed and y-speed seperately?
    if(size(coordinates,1) < 2)
        out = [coordinates(1,1),0,0];
    else
        speed1 = coordinates(1:size(coordinates, 1)-1, 2:3);
        speed2 = coordinates(2:size(coordinates, 1), 2:3);
        %time1 = coordinates(1:size(coordinates, 1)-1, 1);
        %time2 = coordinates(2:size(coordinates, 1), 1);
        out(:,1) = coordinates(:,1);
        out(size(out, 1), :) = [];
        for i = 1:size(speed1, 2)
            out(:,i+1) = ((speed1(:,i) - speed2(:,i))); %./ ((time2 - time1));
        end
    end
