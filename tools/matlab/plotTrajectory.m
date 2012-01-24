function [] = plotTrajectory( SessionCoordinates, ClusterCoordinates )
%PLOTTRAJECTORY Plots a trajectory on a map
%   INPUT:
%   time - an Nx1 vector of time-stamps
%   Coordinates - Nx2 matrix containing XY-coordinates

% open a new figure and make sure its clear

if nargin < 2
    ClusterCoordinates = [];
    hasCluster = false;
else
    hasCluster = true;
end

sessionX = SessionCoordinates(:, 1);
sessionY = SessionCoordinates(:, 2);

if hasCluster
    clusterX = ClusterCoordinates(:, 1);
    clusterY = ClusterCoordinates(:, 2);
end

hold('on')

cur = gca();

pos = get(cur, 'Position');
figureRatio = pos(4)/pos(3); %width/height
correctionRatio = pos(3)/pos(4);

minY = min(sessionY);
maxY = max(sessionY);
yDiff = maxY - minY;

minX = min(sessionX);
maxX = max(sessionX);
xDiff = maxX - minX;

yDiffScaled = yDiff*figureRatio;

%if xDiff > yDiffScaled
%    % long full
%    % lat scaled to fit figure
%    yMargin = (yDiff * correctionRatio)/2;
%    minY = minY-yMargin;
%    maxY = maxY+yMargin;
%elseif yDiffScaled > xDiff
%    % long scaled to fit figure
%    % lat full
%    xMargin = (xDiff * correctionRatio)/2;
%    minX = minX-xMargin;
%    maxX = maxX+xMargin;
%end

axis([minY maxY minX maxX]);

geoshow(gca, 'plot/nh_zh_shape/nh_zh_shape.shp',...
    'LineWidth',  1, ...
    'FaceColor', [1.0 0.9 0.5], ...
    'EdgeColor', [0.5 0.5 0.5]);
geoshow(gca, sessionX, sessionY, ...
    'LineWidth',  2, ...
    'color', 'b');

if ~hasCluster
    geoshow(gca, sessionX, sessionY, ...
    'DisplayType',  'point', 'MarkerSize', 3, 'MarkerEdgeColor', 'green');
end

if hasCluster
    geoshow(gca, clusterX, clusterY, ...
        'LineWidth', 2,  ...
        'color', 'g');
end

hold('off')

end

