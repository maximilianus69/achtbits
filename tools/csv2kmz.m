function []=GPSvis_course(name_dat)
% This function uses the Matlab2GoogleEarth toolbox. 
% Make sure that it is installed and you set the path right.
%% copy name of data-file to kml-file
name_dat='newSample.csv';
name_kml=name_dat;
name_kml(end-3:end)='.kmz';

data=importdata(name_dat);
% IN MY EXAMPLE THIS FILE HAS NOW THE STRUCTURE:
% Summary=[sensor(i).ID' ...
%           sensor(i).year' sensor(i).month' sensor(i).day' ...
%           sensor(i).hour' sensor(i).min' sensor(i).sec' ...
%           sensor(i).time'  sensor(i).Long' sensor(i).Lat' ...
%           sensor(i).Alt' sensor(i).Pres' sensor(i).Temp' ...
%           sensor(i).nrSat' sensor(i).TimeToFix' sensor(i).PosDop' ...
%           sensor(i).horAcc' sensor(i).vertAcc' sensor(i).SpeedX' ...
%           sensor(i).SpeedY' sensor(i).SpeedZ' sensor(i).SpeedAcc' ...
%           sensor(i).CSpeed' sensor(i).CSpeedGPS'];

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

year='x';
ID=data(:,1);
month='x';
day='x';
hour='x';
min='x';
sec='x';
time=data(:,2);
Long=data(:,7);
Lat=data(:,8);
Alt=data(:,9);
CSpeedGPS='x';
CSpeed='x';
nrSat='x';
Time2Fix='x';
PosDop='x';

kmlStr=''; % start with empty kml

% numTime = datenum(year,month,day,hour,min,sec);
%     Ix = find(year<1900|year>2015);
%     numTime(Ix)=NaN; 
%     clear Ix;
% dateTimeFormat = 'yyyy-mm-ddTHH:MM:SSZ';
numTime = time;

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

%This is the line that connects the points
kmlStr = [kmlStr,ge_plot(Long, Lat,...
                        'lineColor',colortable1(2,:),...
                        'lineWidth',1)];

%% FOR-loop to add every datapoint to the kml-file
for i=2:length(Long)-1

     % set time stamp
     tNumPrev = numTime(i-1);
     tNumNow = numTime(i);
     tNumNext = numTime(i+1);
     if isnan(tNumPrev)&&~isnan(tNumNow)
         tStart = tNumNow+datenum([0,0,0,-1,0,0]);
     elseif ~isnan(tNumPrev)&&~isnan(tNumNow)
         tStart = mean([tNumPrev;tNumNow]);
     else
         clear tNumPrev
         clear tNumNow
         clear tNumNext
         clear tStart
         clear tStop
         continue
     end
        
     if isnan(tNumNext)&&~isnan(tNumNow)
         tStop = tNumNow+1;
     elseif ~isnan(tNumNext)&&~isnan(tNumNow)
         tStop = mean([tNumNext;tNumNow]);
     else
         clear tNumPrev
         clear tNumNow
         clear tNumNext
         clear tStart
         clear tStop
         continue
     end

%      % if available use CSpeedGPS (instanteneous)for colors, 
%      % else CSpeed (trajectory)
%      % choose the speedclasses as you like
%      if isnan(CSpeedGPS(i))
%         SpeedClass=4;
%         if CSpeed(i)<20
%             SpeedClass=3;
%             if CSpeed(i)<10
%                 SpeedClass=2;
%                 if CSpeed(i)<2
%                     SpeedClass=1;
%                 end;
%             end;
%         end;
%       else
%         SpeedClass=4;
%         if CSpeedGPS(i)<20
%             SpeedClass=3;
%             if CSpeedGPS(i)<10
%                 SpeedClass=2;
%                 if CSpeedGPS(i)<2
%                     SpeedClass=1;
%                 end;
%             end;
%         end;
%      end

    SpeedClass=1;

     % If Altitude is available, scale the size of the icon
     % If no altitude is NaN -> else colortable 9=transparent black dot
     % explanation is given first (cf documentation ge_point
     % http://www.mathworks.com/matlabcentral/fx_files/12954/4/content/googleearth/html/ge_point.html
%      kmlStr = [kmlStr,ge_point(Long(i),...  | Lat, Long, Alt of point
%           Lat(i),...
%           Alt(i),...
%           'iconURL',iconStr,...             | icon type
%           'altitudeMode','absolute',...     | 'absolute','relativeToGround' or 'clampToGround'
%           'extrude',1,...                   | white line that connects to surface
%           'name','',...
%           'iconColor',colortable(SpeedClass,:),...             | specifies color
%           'iconScale',0.3+log10(max(1,Alt(i)))/10,...          | rescales the icon
%           'pointDataCell',{'UTM time',datestr(tNumNow,0);...   | from here all the data that are ...
%                                             | shown in the box that opens upon clicking the icon
%                                             | numeric values are transformed to strings
%           'sensor ID',num2str(ID(i));...
%           'sensor time',num2str(time(i),8);...
%           'record index',num2str(i);...
%           'lat long',[num2str(Long(i))...   | Lat and Long on one row to save memory
%           '  ' num2str(Lat(i))];...
%           'altitude [m]',num2str(Alt(i));...
%           'T-P Speed [km/h]',[num2str(CSpeed(i))...            | Both speeds on one row to save memory
%           '  ' num2str(CSpeedGPS(i))];},... 
%           'timeSpanStart',tStart,...        | for time ruler
%           'timeSpanStop',tStop)];

     if  ~isnan(Alt(i)) 
            colortable=colortable1; 
            kmlStr = [kmlStr,ge_point(Long(i),...
                      Lat(i),...
                      Alt(i),...
                      'iconURL',iconStr,...
                      'altitudeMode','relativeToGround',...
                      'extrude',1,...
                      'name','',...
                      'iconColor',colortable(SpeedClass,:),...
                      'iconScale',0.3+log10(max(1,Alt(i)))/10,...
                      'timeSpanStart',tStart,...
                      'timeSpanStop',tStop)];
        else
           colortable=Colortable(:,:,9); 
            colortable=colortable1;
            kmlStr = [kmlStr,ge_point(Long(i),...
                      Lat(i),...
                      10,...
                      'iconURL',iconStr,...
                      'altitudeMode','relativeToGround',...
                      'extrude',1,...
                      'name','',...
                      'iconColor',colortable(SpeedClass,:),...
                      'iconScale',0.3,...
                      'pointDataCell',{'UTM time',datestr(tNumNow,0);...
                          'sensor ID',num2str(ID(i));...
                          'sensor time',num2str(time(i),8);...
                          'record index',num2str(i);...
                          'lat long',[num2str(Long(i))...
                          '  ' num2str(Lat(i))];...
                          'altitude [m]',num2str(Alt(i));...
                          'T-P Speed [km/h]',[num2str(CSpeed(i))...
                           '  ' num2str(CSpeedGPS(i))];},...
                      'timeSpanStart',tStart,...
                      'timeSpanStop',tStop)];
     end
end

%write the kmz-file in the current directory
ge_output(name_kml,kmlStr)
