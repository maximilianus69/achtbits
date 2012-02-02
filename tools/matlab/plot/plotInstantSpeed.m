function out = plotInstantSpeed( ClusterGpsData )
%PLOT_INSTANT_SPEED Plots velocity vectors of momentary speed
%
% SessionGpsData: data as outputted by gpsread

time = ClusterGpsData(:,2);

% normalize times to start at 0 and convert to zeros
beginTime = time(1);
timeNorm = (time - beginTime)/60;

hold on;

 x = timeNorm;
y = zeros(size(ClusterGpsData,1),1);
speedx = ClusterGpsData(:,9);
speedy = ClusterGpsData(:,10);

% this line makes scaling of the axis equal so the arrows dont get
% deformed, but it also breaks the alignment of timestamps with other plots
axis equal;

quiver(x, y, speedx, speedy);

title('Instantanious Speed Vectors');
hold off;

% plot(x, ClusterGpsData(:,5));
% hold off;