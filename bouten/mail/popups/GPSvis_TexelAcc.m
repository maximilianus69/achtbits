%function []=GPSvis_course(name_dat)
% This function uses the Matlab2GoogleEarth toolbox. 
% Make sure that it is installed and you set the path right.
%% copy name of data-file to kml-file
clear all
name_dat='S538_1507_1507.txt';
Filename=name_dat;
Filename(end-3:end)='.kmz';
load WB;

data=load(name_dat);
% IN MY EXAMPLE THIS FILE HAS NOW THE STRUCTURE:

% Summary=[sensor(i).ID' ...
%           sensor(i).year' sensor(i).month' sensor(i).day' ...
%           sensor(i).hour' sensor(i).min' sensor(i).sec' ...
%           sensor(i).time'  sensor(i).Long' sensor(i).Lat' ...
%           sensor(i).Alt' sensor(i).Pres' sensor(i).Temp' ...
%           sensor(i).nrSat' sensor(i).TimeToFix' sensor(i).PosDop' ...
%           sensor(i).horAcc' sensor(i).vertAcc' sensor(i).SpeedX' ...
%           sensor(i).SpeedY' sensor(i).SpeedZ' sensor(i).SpeedAcc' ...
%           sensor(i).CSpeed' sensor(i).CSpeedGPS' sensor(i).Dist' ...
%           sensor(i).G1' sensor(i).A' ...
%           sensor(i).Xmean' sensor(i).Ymean' sensor(i).Zmean' ...
%           sensor(i).Xstd' sensor(i).Ystd' sensor(i).Zstd' ... 
%           sensor(i).Xmchange' sensor(i).Ymchange' sensor(i).Zmchange' ... 
%           sensor(i).Xmin' sensor(i).Ymin' sensor(i).Zmin' ...
%           sensor(i).Class'];

Year=data(1,2);
ID=str2num(name_dat(2:4));
Month=data(:,3);
Day=data(:,4);
Hour=data(:,5);
Min=data(:,6);
Sec=data(:,7);
Time=data(:,8);
Long=data(:,9);
Lat=data(:,10);
Alt=data(:,11);
CSpeedGPS=data(:,25);
CSpeed=data(:,24);
nrSat=data(:,12);
Time2Fix=data(:,13);
PosDop=data(:,14);
Class=data(:,40);
ClassText='stand sit walk preenflap soar floatflfl no-cl';




mkdir('./png');     % create png directory
kmlStr='';          % start with empty kml

numTime = datenum(Year,Month,Day,Hour,Min,Sec);
    Ix = find(Year<1900|Year>2015);
    numTime(Ix)=NaN; 
    clear Ix;
dateTimeFormat = 'yyyy-mm-ddTHH:MM:SSZ';

% set the icontype   
iconStr = ['http://maps.google.com/','mapfiles/kml/pal2/icon26.png'];

% Set the Colortables (these are some examples that you can use)
Colortable(:,:,1)=['ff0587ff';'FF0054FF';'FF0000EB'; 'FF00008d']; %OK Orange-Red
Colortable(:,:,2)=['FF17FCFF';'FF17D0FD';'FF17B9FB'; 'FF1778AF']; %OK Yellow
Colortable(:,:,3)=['ffffc6fd';'ffdba2d9';'ffa36aa1'; 'ff753c73']; %OK Pink-Purper
Colortable(:,:,4)=['ffd9d900';'ffc5c500';'ffb1b100'; 'ff979700']; %OK Blue
Colortable(:,:,5)=['ffffffff';'ffdfdfdf';'ffafafaf'; 'ff6f6f6f']; %OK White-Grey
Colortable(:,:,6)=['ffe0ffe0';'ffb2ffb2';'ff8cff8c'; 'ff00ff00']; %OK Green
Colortable(:,:,7)=['ffbcbcfd';'ff9494d5';'ff6c6cad'; 'ff3a3a7b']; %OK Pink
Colortable(:,:,8)=['ffffffdc';'ffffffb4';'ffffff78'; 'ffffff00']; %OK light Blue
Colortable(:,:,9)=['7d000000';'7d000000';'7d000000'; '7d000000']; %OK black - transparent

colortable1=Colortable(:,:,1); % choose the colortable of your choice
% 
%This is the line that connects the points
kmlStr = [kmlStr,ge_plot(Long, Lat,...
                        'lineColor',colortable1(2,:),...
                        'lineWidth',1)];

%% FOR-loop to add every datapoint to the kml-file
for i=2:length(Long)-1

     % set time stamp
     tNumPrev = datenum(numTime(i-1));
     tNumNow = datenum(numTime(i));
     tNumNext = datenum(numTime(i+1));
     if isnan(tNumPrev)&&~isnan(tNumNow)
         tStart = datestr(tNumNow+datenum([0,0,0,-1,0,0]),dateTimeFormat);
     elseif ~isnan(tNumPrev)&&~isnan(tNumNow)
         tStart = datestr(mean([tNumPrev;tNumNow]),dateTimeFormat);
     else
         clear tNumPrev
         clear tNumNow
         clear tNumNext
         clear tStart
         clear tStop
         continue
     end

     if isnan(tNumNext)&&~isnan(tNumNow)
         tStop = datestr(tNumNow+datenum([0,0,0,+1,0,0]),dateTimeFormat);
     elseif ~isnan(tNumNext)&&~isnan(tNumNow)
         tStop = datestr(mean([tNumNext;tNumNow]),dateTimeFormat);
     else
         clear tNumPrev
         clear tNumNow
         clear tNumNext
         clear tStart
         clear tStop
         continue
     end
    
     SpeedClass=3;
     if Class(i)== 1
            colortable1=Colortable(:,:,4);         
        elseif Class(i)== 2
            colortable1=Colortable(:,:,2);         
        elseif Class(i)== 3
            colortable1=Colortable(:,:,3);         
        elseif Class(i)== 4
            colortable1=Colortable(:,:,5);         
        elseif Class(i)== 5
            colortable1=Colortable(:,:,1);         
        elseif Class(i)== 6
            colortable1=Colortable(:,:,6);         
        elseif Class(i)== 7
            colortable1=Colortable(:,:,7);         
        elseif Class(i)== 8
            colortable1=Colortable(:,:,8);         
        elseif Class(i)== 9 || isnan(Class(i))
            colortable1=Colortable(:,:,9);         
     end


     if  ~isnan(Alt(i))

        extraData = {'UTM time',datestr(tNumNow,0);...
                     'sensor ID',num2str(ID);...
                     'sensor time',num2str(Time(i),8);...
                     'record index',num2str(i);...
                     'lat long',[num2str(Long(i))...
                     '  ' num2str(Lat(i))];...
                     'altitude [m]',num2str(Alt(i));...
                     'T-P Speed [km/h]',[num2str(CSpeed(i))...
                      '  ' num2str(CSpeedGPS(i))];...
                     'Dist [km]', num2str(Dist(i));...
                     'Class', ClassText(5*(Class(i)-1)+1:5*(Class(i)-1)+5);...
                     'record index',num2str(i)};

        bgColor = {'#D0D0D0';'#F0F0F0'};
        htmlStr = ['<TABLE border="0px">',char(10)];
        clear pngFileName
        if isnan(Class(i))==0
            pngFileName = ['./png/accelero',num2str(i,'%04d'),'.png'];
            writeAccPNG(pngFileName, acc, i);
            htmlStr = [htmlStr,'<TR><TD colspan="2"><img src="',pngFileName,'"></TD></TR>',char(10)];                
        end
        for iRow = 1:size(extraData,1)
            htmlStr = [htmlStr,'<TR bgcolor="',bgColor{1+mod(iRow,2),1},'"><TD>',extraData{iRow,1},'</TD>',...
                '<TD>',extraData{iRow,2},'</TD></TR>',char(10)];
        end
        htmlStr = [htmlStr,'</TABLE>'];

        if Alt(i)>0
            kmlStr = [kmlStr,ge_point(Long(i),...
                  Lat(i),...
                  Alt(i),...
                  'iconURL',iconStr,...
                  'altitudeMode','absolute',...
                  'extrude',1,...
                  'name','',...
                  'iconColor',colortable1(SpeedClass,:),...
                  'iconScale',0.4,...
                  'description',htmlStr,...
                  'timeSpanStart',tStart,...
                  'timeSpanStop',tStop)];
        else
            kmlStr = [kmlStr,ge_point(Long(i),...
                  Lat(i),...
                  Alt(i),...
                  'iconURL',iconStr,...
                  'altitudeMode','clampToGround',...
                  'extrude',1,...
                  'name','',...
                  'iconColor',colortable1(SpeedClass,:),...
                  'iconScale',0.4,...
                  'description',htmlStr,...
                  'timeSpanStart',tStart,...
                  'timeSpanStop',tStop)];
        end
     else
       %colortable=Colortable(:,:,9); 
       kmlStr = [kmlStr,ge_point(Long(i),...
                  Lat(i),...
                  10,...
                  'iconURL',iconStr,...
                  'altitudeMode','clampToGround',...
                  'extrude',1,...
                  'name','',...
                  'iconColor',colortable(SpeedClass,:),...
                  'iconScale',0.4,...
                  'description',htmlStr,...
                  'timeSpanStart',tStart,...
                  'timeSpanStop',tStop)];
     end  %~isnan(Alt(i))


end
clear i
%Filename=['SAS_' num2str(allChildIDs(j)) '_' SortFiles(1).name(10:13) '_' SortFiles(NrFiles).name(10:13) 'pngPU.kmz'];
ge_output(Filename,kmlStr)
kmlStr=[];


