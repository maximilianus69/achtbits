function [] = plotTrajectory( SessionCoordinates, ClusterCoordinates, sessionZoom )
%PLOTTRAJECTORY Plots a trajectory on a map
%   INPUT:
%   time - an Nx1 vector of time-stamps
%   Coordinates - Nx2 matrix containing XY-coordinates

% open a new figure and make sure its clear

%set(gca, 'XTickLabel', '');
%set(gca, 'YTickLabel', '');

if nargin < 2
    ClusterCoordinates = [];
    hasCluster = false;
else
    hasCluster = true;
end

if nargin < 3
    zoom = false;
else
    zoom = sessionZoom;
end
    

sessionX = SessionCoordinates(:, 2);
sessionY = SessionCoordinates(:, 1);

if hasCluster
    clusterX = ClusterCoordinates(:, 2);
    clusterY = ClusterCoordinates(:, 1);
end

set(gca, 'Units', 'pixels')
pos = get(gca, 'Position');
figureRatio = pos(4)/pos(3); %width/height
correctionRatio = pos(3)/pos(4);
set(gca, 'Units', 'normalized')

minY = min(sessionY);
maxY = max(sessionY);
yDiff = maxY - minY;

minX = min(sessionX);
maxX = max(sessionX);
xDiff = maxX - minX;

yDiffScaled = yDiff*figureRatio;

if xDiff > yDiffScaled
   % long full
   % lat scaled to fit figure
   yMargin = (yDiff * correctionRatio)/2;
   minY = minY-yMargin;
   maxY = maxY+yMargin;
elseif yDiffScaled > xDiff
   % long scaled to fit figure
   % lat full
   xMargin = (xDiff * correctionRatio)/2;
   minX = minX-xMargin;
   maxX = maxX+xMargin;
end
if hasCluster && ~zoom
    axis([3 5 53.3-(2*figureRatio) 53.3]);
else
    axis([minX maxX minY maxY]);
end
%axis([minX maxX minY maxY]);
% hold('on')

% plot the map
geoshow(gca, 'plot/nl_shape/netherlands_land.shp',...
    'LineWidth',  1, ...
    'FaceColor', [1.0 0.9 0.5], ...
    'EdgeColor', [0.5 0.5 0.5]);

% show session trajectory
geoshow(gca, sessionY, sessionX, ...
    'LineWidth',  1, ...
    'color', 'b');

if hasCluster
    markerSize = 1;
else
    markerSize = 5; 
end

%if ~hasCluster
    geoshow(gca, sessionY, sessionX, ...
    'DisplayType',  'point', 'MarkerSize', markerSize, 'MarkerEdgeColor', 'r');
%end

if hasCluster
    geoshow(gca, clusterY, clusterX, ...
        'LineWidth', 1,  ...
        'color', 'g');
end

if hasCluster
    geoshow(gca, sessionY(1), sessionX(1), 'DisplayType',  'point', 'Marker', 'square', 'MarkerSize', 10, 'MarkerEdgeColor', 'r')
    geoshow(gca, clusterY(1), clusterX(1), 'DisplayType',  'point', 'Marker', 'square', 'MarkerSize', 5, 'MarkerEdgeColor', 'g')
else
    geoshow(gca, sessionY(1), sessionX(1), 'DisplayType',  'point', 'Marker', 'square', 'MarkerSize', 10, 'MarkerEdgeColor', 'g')

end

% hold('off')

end

