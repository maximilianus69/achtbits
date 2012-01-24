function plotFeatureInfo( Feature, classes )
%PLOT_FEATURE_INFO plots the text info of cluster features
%   Detailed explanation goes here

% Feature format:
%[startTime, endTime, duration, avgSpeed, heightDiff, grndDist]
       
axis([0 6 5 10]);
axis off;

set(0, 'DefaultTextHorizontalAlignment', 'left');
set(0, 'DefaultTextFontSize', 13);
set(0, 'DefaultAxesFontSize', 10);

text(1, 10, 'Nr.');
text(1, 9, 'Dur.');
text(1, 8, 'Avg vel.');
text(1, 7, 'Y diff');
text(1, 6, 'Abs dist');
text(1, 5, 'Tot dist');
text(1, 4, 'Prev.');

text(3, 10, num2str(Feature(1))); % cluster
%text(2, 9, strcat(num2str(Feature(4)), ' sec')); % duration
%text(2, 8, strcat(num2str(Feature(5)), ' m/s')); % speed
text(3, 7, strcat(num2str(Feature(6)), ' m')); % height diff
text(3, 6, strcat(num2str(Feature(7)), ' km')); % abs distance
text(3, 5, strcat(num2str(Feature(8)), ' km')); % tot distance
text(3, 4, classes(Feature(end)));

text(3, 9, secs2hms(Feature(4))); % duration
text(3, 8, strcat(num2str(Feature(5)*3.6), ' km/h')); % speed
%text(4, 7, strcat(num2str(Feature(6)/1000), ' km')); % height diff
