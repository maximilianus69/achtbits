function [] = plotTrajectory( SessionCoordinates, ClusterCoordinates )
%PLOTTRAJECTORY Plots a trajectory on a map
%   INPUT:
%   time - an Nx1 vector of time-stamps
%   Coordinates - Nx2 matrix containing XY-coordinates

% open a new figure and make sure its clear

sessionX = SessionCoordinates(:, 1);
sessionY = SessionCoordinates(:, 2);

clusterX = ClusterCoordinates(:, 1);
clusterY = ClusterCoordinates(:, 2);

%geoshow(gca, 'nh_zh_shape.shp');
hold('on')

geoshow(gca, sessionX, sessionY, 'color', 'b');

geoshow(gca, clusterX, clusterY, 'color', 'r');
hold('off')

end

