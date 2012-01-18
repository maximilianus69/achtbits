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

hold('on')
axis([min(sessionY)-0.05 max(sessionY)+0.05 min(sessionX)-0.05 max(sessionX)+0.05]);

geoshow(gca, 'plot/nh_zh_shape/nh_zh_shape.shp', ...
    'FaceColor', [1.0 0.9 0.5], ...
    'EdgeColor', [0.5 0.5 0.5]);
geoshow(gca, sessionX, sessionY, 'color', 'b');
geoshow(gca, clusterX, clusterY, 'color', 'r');

hold('off')

end

