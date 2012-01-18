function createAnnotateUi(Elements)
    %CREATE_ANNOTATE_UI Summary of this function goes here
    %   Detailed explanation goes here
   
    figure;
    axis off;

    height = 40;
    width = 200;
    spacing = 20;
    
    figure('Position', [0, 0, width+2*spacing, length(Elements)*(spacing+height)]);

    for i = 1:length(Elements)
        uicontrol('Style', 'pushbutton', 'String', Elements(end+1-i),...
                'Position', [20 (spacing+height)*i width 40],...
                'Callback', {@callbck, Elements(end+1-i)});
    end
       
function callbck(hObject, eventdata, var)
    msgbox(var);