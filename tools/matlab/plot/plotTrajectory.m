function plotTrajectory( SessionCoordinates, ClusterCoordinates, sessionZoom )
%PLOTTRAJECTORY Plots a trajectory on a map
%
%   INPUT:
%   SessionCoordinates - Nx2 matrix containing XY-coords main plot
%   ClusterCoordinates - Nx2 matrix containing XY-coordinates of cluster
%   sessionZoom        - boolean that tells function to zoom on main plot
%
% this function is used to plot both the session and the cluster plot
% if this is a session plot then the second argument contains the current
% cluster which is highlighted in the session plot.
% else if this is a cluster plot, it only has one argument

% check if this is a session or cluster plot
if nargin < 2
    ClusterCoordinates = [];
    isSessionPlot = false;
else
    isSessionPlot = true;
end

% check if there is a zoom argument
if nargin < 3
    zoom = true;
else
    zoom = sessionZoom;
end 

sessionX = SessionCoordinates(:, 2);
sessionY = SessionCoordinates(:, 1);

if isSessionPlot
    clusterX = ClusterCoordinates(:, 2);
    clusterY = ClusterCoordinates(:, 1);
end

% this next part is used to determine the scaling of the plot

% find the ratio of the figure we are plotting in
set(gca, 'Units', 'pixels')
pos = get(gca, 'Position');
figureRatio = pos(3)/pos(4); %height/width
set(gca, 'Units', 'normalized')

% find the total X and Y
minY = min(sessionY);
maxY = max(sessionY);
yDiff = maxY - minY;

minX = min(sessionX);
maxX = max(sessionX);
xDiff = maxX - minX;

% scale the total Y to figure ratio
yDiffScaled = yDiff*figureRatio;

% check if X or scaledY is the biggest so we know what side should be fully
% used
if xDiff > yDiffScaled
   yMargin = (xDiff - yDiffScaled)/2;
   minY = minY-yMargin;
   maxY = maxY+yMargin;
elseif yDiffScaled > xDiff
   xMargin = (yDiffScaled - xDiff)/2;
   minX = minX-xMargin;
   maxX = maxX+xMargin;
end

% if this is a session plot without zoom then used a fixed position on the
% map
% else determine position on the map with the calculated margins
if isSessionPlot && ~zoom
    xScaled = (2.2*figureRatio)/2;
    axis([4.4-xScaled 4.4+xScaled 51.2 53.4]);
else
    axis([minX-xDiff*0.02 maxX+xDiff*0.02 minY-yDiff*0.02 maxY+yDiff*0.02]);
end

% plot the map
geoshow(gca, 'plot/nl_shape/netherlands_land.shp',...
    'LineWidth',  1, ...
    'FaceColor', [1.0 0.9 0.5], ...
    'EdgeColor', [0.5 0.5 0.5]);

% show session trajectory
geoshow(gca, sessionY, sessionX, ...
    'LineWidth',  1, ...
    'color', 'b');

% this if statement is not used right now but is optional (see next part)
% if isSessionPlot
%     markerSize = 1;
% else
%     markerSize = 5; 
% end

% if the next part is taken out of the if statement and the previous if
% statement is uncommented then session plot also has mmarkers on every
% data point
if ~isSessionPlot
    geoshow(gca, sessionY, sessionX, ...
    'DisplayType',  'point', 'MarkerSize', markerSize, 'MarkerEdgeColor', 'r');
end

% plot highlighted cluster and mark start of cluster and session
if isSessionPlot
    geoshow(gca, clusterY, clusterX, ...
        'LineWidth', 1,  ...
        'color', 'c');
    geoshow(gca, sessionY(1), sessionX(1), 'DisplayType',  'point', 'Marker', 'square', 'MarkerSize', 10, 'MarkerEdgeColor', 'r')
    geoshow(gca, clusterY(1), clusterX(1), 'DisplayType',  'point', 'Marker', 'square', 'MarkerSize', 5, 'MarkerEdgeColor', 'g')
else
    geoshow(gca, sessionY(1), sessionX(1), 'DisplayType',  'point', 'Marker', 'square', 'MarkerSize', 10, 'MarkerEdgeColor', 'g')
end


end

