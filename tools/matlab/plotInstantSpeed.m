function out = plotInstantSpeed( SessionGpsData )
%PLOT_INSTANT_SPEED Plots velocity vectors of momentary speed
%
% SessionGpsData: data as outputted by gpsread

time = SessionGpsData(:,2);

% normalize times to start at 0 and convert to zeros
beginTime = time(1);
timeNorm = (time - beginTime)/60;

hold on;

x = timeNorm;
y = ones(size(SessionGpsData,1),1);
speedx = SessionGpsData(:,9);
speedy = SessionGpsData(:,10);

quiver(x, y, speedx, speedy);

title('Instantanious Speed Vectors');
hold off;
