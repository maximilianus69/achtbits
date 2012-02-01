%function [AllMean,AllStd,FftCont]=BPfft(acc)
function writeAccPNG(pngFileName, acc, ii)

%[blocks dum]=size(acc.accX);
cal(538,1:6)=[-298 1280.8 -131.5 1334.5 229.9 1301.5];%					
cal(325,1:6)=[-69 1253.4 -59.9 1339.4 48.0 1294.6]; %					
cal(327,1:6)=[86 1332.8 4.3 1314.7 27.8 1315.9]; %					
cal(344,1:6)=[-272 1302.6 -126.3 1331.8 204.8 1301.0]; %					
cal(355,1:6)=[-8.33 1292.3 -54.4 1329.2 39 1319];
cal(373,1:6)=[-390 1242.2 -193 1338.7 240 1315.9];


 
 scrsz = get(0,'ScreenSize');

    clear aX bX cX
    aX=[]; aX=acc(1).accX{ii,:}; aX(1)=[]; aX=(aX-cal(acc.ID(1),1))/cal(acc.ID(1),2);
    aY=[]; aY=acc(1).accY{ii,:}; aY(1)=[]; aY=(aY-cal(acc.ID(1),3))/cal(acc.ID(1),4);
    aZ=[]; aZ=acc(1).accZ{ii,:}; aZ(1)=[]; aZ=(aZ-cal(acc.ID(1),5))/cal(acc.ID(1),6);
    
   X=aX; Y=aY; Z=aZ;IDii(ii)=ii;
   L=length(Z);

   if acc.hour(ii) >= 10
       hstr=num2str(acc.hour(ii));
   else
       hstr=['0',num2str(acc.hour(ii))];
   end
   if acc.min(ii) >= 10
       mstr=num2str(acc.min(ii));
   else
       mstr=['0',num2str(acc.min(ii))];
   end
   if acc.sec(ii) >= 10
       sstr=num2str(acc.sec(ii));
   else
       sstr=['0',num2str(acc.sec(ii))];
   end
    set(figure(2), 'Position',[50 50 scrsz(3)/5 scrsz(4)/6]);    axes('fontsize',16);
%    Subplot(5,2,ii-10*floor((ii-1)/10))
   plot((1:length(aX))*0.05,aX, 'ro-','LineWidth',2,  'MarkerSize',8); ylim([-1.5 2.5]); grid on
   hold on
   plot((1:length(aY))*0.05,aY, 'bo-','LineWidth',2,  'MarkerSize',8)
   plot((1:length(aZ))*0.05,aZ, 'go-','LineWidth',2,  'MarkerSize',8)
   title(['T= ', hstr,mstr,sstr,' Xred, Yblue, Zgreen nr  ', num2str(ii)],'fontsize',16);
   xlabel('time (sec)','fontsize',16); %legend('X', 'Y', 'Z');

   drawnow
   print ('-dpng', pngFileName,'-r72')
close(figure(2))
