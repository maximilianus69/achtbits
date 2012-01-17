function pick = showControls(Buttons)
%ANNOTATE_CONTROL creates control buttons for annotating data
%
% Arguments:
%	- Buttons a list of buttons, also the callback arguments
%
% Returns:
%	Index of buttons pressed

N = length(Buttons);
buttonH = 60;

close all;
figid = figure('Position', [600 200 400 buttonH*N], 'color', 'white');
hold on;
axis([0 10 0 N]);
axis off;

for i = 1:N
	line(xlim, [i i]);
	text(0, i-0.3, Buttons(i), 'fontsize', 20);
end

[ix, iy] = ginput(1);

pick = floor(iy)+1;

close(figid);
