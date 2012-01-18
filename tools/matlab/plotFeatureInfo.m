function plotFeatureInfo( Feature, classes )
%PLOT_FEATURE_INFO plots the text info of cluster features
%   Detailed explanation goes here

% Feature format:
%[startTime, endTime, duration, avgSpeed, heightDiff, grndDist]
       
axis([0 6 5 10]);
axis off;

set(0, 'DefaultTextHorizontalAlignment', 'right');


text(1, 10, 'Cluster');
text(1, 9, 'Duration');
text(1, 8, 'Avg speed');
text(1, 7, 'Height diff');
text(1, 6, 'Abs distance');
text(1, 5, 'Tot distance');
text(1, 4, 'Previous class');


set(0, 'DefaultTextHorizontalAlignment', 'left');

text(2, 10, num2str(Feature(1))); % cluster
text(2, 9, strcat(num2str(Feature(4)), ' sec')); % duration
text(2, 8, strcat(num2str(Feature(5)), ' m/s')); % speed
text(2, 7, strcat(num2str(Feature(6)), ' m')); % height diff
text(2, 6, strcat(num2str(Feature(7)), ' km')); % abs distance
text(2, 5, strcat(num2str(Feature(8)), ' km')); % tot distance
if Feature(9) > 0 
    text(2, 4, classes(Feature(9)));
end

text(4, 9, strcat(num2str(Feature(4)/3600), ' hr')); % duration
text(4, 8, strcat(num2str(Feature(5)*3.6), ' km/h')); % speed
text(4, 7, strcat(num2str(Feature(6)/1000), ' km')); % height diff
