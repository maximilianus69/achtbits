function out = derivative(Coordinates)
    % DERIVATIVE: Calculates the differences in the data that is put in.
    % 
    % Input: Coordinates: a matrix with timestamps in the first column, and (in
    % our case) speed in the second column
    %
    % Output: out: a matrix containing the same timestamps as went in in the
    % first column, but containing the differences between the speeds in the
    % second.

    if(size(Coordinates,1) < 2)
        out = [Coordinates(1,1),0,0];
    else
        for i = 1:size(Coordinates, 1)
            Normals(i, 1) = norm(Coordinates(i, 2:3));
        end
        speed1 = Normals(1:size(Normals, 1)-1, :);
        speed2 = Normals(2:size(Normals, 1), :);
        out(:,1) = Coordinates(:,1);
        out(size(out, 1), :) = [];
        for i = 1:size(speed1, 2)
            out(:,i+1) = ((speed1(:,i) - speed2(:,i))); %./ ((time2 - time1));
        end
    end
