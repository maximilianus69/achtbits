function pick = showControls(Buttons)
%ANNOTATE_CONTROL creates control buttons for annotating data
%
% Arguments:
%	- Buttons a list of buttons, also the callback arguments
%
% Returns:
%	Index of buttons pressed

N = length(Buttons);

hold on;
axis([0 6 0 N]);
axis off;

for i = 1:N
	line(xlim, [i i]);
	text(0, i-0.4, strcat(num2str(i), ')  ',Buttons(i)), 'fontsize', 16);
end

[ix, iy] = ginput(1);

pick = floor(iy)+1;

