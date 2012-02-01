function handles = makeButtons( hparent, buttons, classColors )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin == 3
    classes = true;
else
    classes = false;
end

marginX = 0.05;
marginY = 0.1;
    
amountOfButtons = size(buttons, 2);

set(hparent, 'Units', 'pixels');
hparentPos = get(hparent, 'Position');
set(hparent, 'Units', 'normalized');
parentWidth = hparentPos(3);
buttonWidthMargin = parentWidth * marginX;
buttonWidth = parentWidth - buttonWidthMargin*2;
parentHeight = hparentPos(4)/amountOfButtons;

buttonHeightMargin = parentHeight * marginY;
buttonHeight = parentHeight - buttonHeightMargin*3;

if buttonHeight > 35
    buttonHeight = 35;
end

handles = zeros(amountOfButtons, 1);

for i = 1:amountOfButtons
    heightOffset = (i-1) * (buttonHeight + buttonHeightMargin) + buttonHeightMargin;
    
    if classes && size(classColors, 1) == amountOfButtons
        color = classColors(i, :);
    else
        color = 'black';
    end
    
    handles(i) = uicontrol('Parent', hparent, 'Style', 'pushbutton', ...
        'String', buttons(i), 'ForegroundColor', color,...
        'Position', [buttonWidthMargin heightOffset buttonWidth buttonHeight]);
    
end

end

