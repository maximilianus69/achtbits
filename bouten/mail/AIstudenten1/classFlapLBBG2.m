clear all
close all
%tic
D=importdata('LBBG355_010701072010.csv');
% cvs contains:{'device_info_serial','date_time','index','x_cal','y_cal','z_cal',
% 'speed','latitude','longitude','altitude';}
% d [device_info_serial','yy mm dd hh mm ss',
% 'index','x_cal','y_cal','z_cal','speed','latitude','longitude','altitude']
minWindowSize=33;
scrsz = get(0,'ScreenSize');
last=-1;
i=1;
iNaN=0;


for i=2:length(D.textdata)
   d(i-1,1)=str2num(D.textdata{i,1});
   d(i-1,2:7)= datevec(D.textdata{i,2});
   %back from vec to str: datestr(d(i,2:7),'yyyy-mm-dd HH:MM:SS')
end
for i=1:length(D.data)
   d(i,8:15)=D.data(i,:);
end 
%save D355_010706072010 d
clear D
%toc


r1 = find(d(:,8)==0);
r2 = find(diff(d(:,8))~=1)+1;
r = unique(sort([1;r1;r2]));

%tic
iF=0;
iO=0;
close all
for i=1:10% length(r)-1
    seriesLength = r(i+1)-r(i);

    %if the number of frames is too small, skip this sample
    if seriesLength<minWindowSize
        continue
    end

    %make windows. see for variable input (for filtering) the windowing function!
    x = d(r(i):r(i)+31,9);
    y = d(r(i):r(i)+31,10);
    z = d(r(i):r(i)+31,11);
    %KinEn 0.5*m*v^2 mass 355 830gr
    %v=vo + at
    v(1)=d(r(i),12)+sqrt(x(1)^2+y(1)^2+(z(1)-1)^2)*0.05*9.81;
    vz(1)=(z(1)-1)*9.81*0.05;
    Alt(1)=d(r(i),15)+0.5*(z(1)-1)*9.81*0.05^2; % hoogteverandering, aanname vo=0.
    for k=2:32
           v(k)=v(k-1)+sqrt(x(k)^2+y(k)^2+(z(k)-1)^2)*0.05*9.81;
           vz(k)=vz(k-1) + (z(k)-1)*9.81*0.05;
           Alt(k)=vz(k-1)*0.05+Alt(k-1)+0.5*(z(1)-1)*9.81*0.05^2;
    end
    KinEn=0.5*830*v.*v;
    PotEn=830*Alt;
    Mx=mean(x); My=mean(y); Mz=mean(z);
    if isnan(Mx) || isnan(My) || isnan(Mz)
        Res(i,1:15)=d(i,1:15);
        Res(i,16:19)=NaN;
        iNaN=iNaN+1;
        continue
    end
    Dx=x-Mx; Dy=y-My; Dz=z-Mz; 
    ODBC(i)=mean(abs(Dx)+abs(Dy)+abs(Dz));
    Stdz(i)=std(z);
    
    %%FFT
    %calculate Fast Fourier Transform
    clear t  Y f Pyy
    t = 0:0.05:1.6;

    XY = fft(x,512);
    PXyy(:,i) = XY.* conj(XY) / 512;
    f = 20*(0:256)/512;
  
    YY = fft(y,512);
    PYyy(:,i) = YY.* conj(YY) / 512;
    
    ZY = fft(z,512);
    PZyy(:,i) = ZY.* conj(ZY) / 512;
 
    dum=find(PZyy(40:256,i)==max(PZyy(40:256,i))); 
    FlapFreq(i)=f(dum+39);

     if  Stdz(i)> 0.5 && ODBC(i)>  0.7 && ODBC(i)< 1.2 && ...
         max(PZyy(40:256,i))>0.25 
%           if 
               class(i)=1;
%           else
%               class(i)=1;
%           end
     else
        class(i)=0;
     end
    
%     if sensor(1).Class(ii)==5 || sensor(1).Class(ii)==8
%      else
%        FlapFreq(ii)=NaN;
%      end

   Res(i,1:15)=d(r(i),1:15);
   Res(i,16)=Stdz(i);
   Res(i,17)=ODBC(i);
   Res(i,18)=class(i); 
   Res(i,19)=FlapFreq(i);
   
   if class(i)==1
        iF=iF+1
       
        set(figure(floor((iF-1)/10)+501), 'Position',[10 40 scrsz(3)/1.1-10 scrsz(4)-135]);
        Subplot(5,4,2*(iF-10*floor((iF-1)/10))-1,'FontSize',5)

        plot(t(2:33),x,'r.-'); xlim([0 1.6]); ylim([-1 2.5]),grid on;
        hold on
        plot(t(2:33),y,'b.-')
        plot(t(2:33),z,'g.-')
            title(['\fontsize{6}',num2str(i),' ID' num2str(d(i,1)),' ', ...
           ' D',num2str(d(i,2)),' ', num2str(d(i,3)),' ', num2str(d(i,4)),' ', ...
           ' T',num2str(d(i,5)),' ', num2str(d(i,6)),' ', num2str(d(i,7)),' ']);
        Subplot(5,4,2*(iF-10*floor((iF-1)/10)),'FontSize',5)
%         plot(f(10:256),PXyy(10:256,i), 'r.-'); xlim([0 10]); ylim([0 0.8]),grid on;
%         hold on
%         plot(f(10:256),PYyy(10:256,i), 'b.-')
%         plot(f(10:256),PZyy(10:256,i), 'g.-')
        plot(t(2:33),v*100 , 'r.-'); hold on ; plot(t(2:33),PotEn , 'b.-')
        title(['\fontsize{6}','C',num2str(class(i)), '  F',num2str(FlapFreq(i))]);
        if (iF/10)-floor(iF/10)<0.05
            if iF<100 
              Filename=['F355_010706072010',num2str(Res(1,1)),'_00',num2str(floor(iF/10)),'.png'] 
            elseif iF<1000 
              Filename=['F355_010706072010',num2str(Res(1,1)),'_0',num2str(floor(iF/10)),'.png'] 
            else
              Filename=['F355_010706072010',num2str(Res(1,1)),'_',num2str(floor(iF/10)),'.png']
            end
           print ('-dpng', '-r200', Filename)
           close
%            if (iF/100)-floor(iF/100)<0.005
%                close all
%            end       
        end       
        
   elseif class(i)==0
       iO=iO+1
       
        set(figure(floor((iO-1)/10)+101), 'Position',[10 40 scrsz(3)/1.1-10 scrsz(4)-135]);
        Subplot(5,4,2*(iO-10*floor((iO-1)/10))-1,'FontSize',5)

        plot(t(2:33),x,'r.-'); xlim([0 1.6]); ylim([-1 2.5]),grid on;
        hold on
        plot(t(2:33),y,'b.-')
        plot(t(2:33),z,'g.-')
            title(['\fontsize{6}',num2str(i),' ID' num2str(d(i,1)),' ', ...
           ' D',num2str(d(i,2)),' ', num2str(d(i,3)),' ', num2str(d(i,4)),' ', ...
           ' T',num2str(d(i,5)),' ', num2str(d(i,6)),' ', num2str(d(i,7)),' ']);
        Subplot(5,4,2*(iO-10*floor((iO-1)/10)),'FontSize',5)
        plot(f(10:256),PXyy(10:256,i), 'r.-'); xlim([0 10]); ylim([0 0.8]),grid on;
        hold on
        plot(f(10:256),PYyy(10:256,i), 'b.-')
        plot(f(10:256),PZyy(10:256,i), 'g.-')
        title(['\fontsize{6}','C',num2str(class(i)), '  F',num2str(FlapFreq(i))]);
        if (iO/10)-floor(iO/10)<0.05
            if iO<100 
              Filename=['O355_010706072010',num2str(Res(1,1)),'_00',num2str(floor(iO/10)),'.png'] 
            elseif iF<1000 
              Filename=['O355_010706072010',num2str(Res(1,1)),'_0',num2str(floor(iO/10)),'.png'] 
            else
              Filename=['O355_010706072010',num2str(Res(1,1)),'_',num2str(floor(iO/10)),'.png']
            end
           print ('-dpng', '-r200', Filename)
           close
%            if (iO/100)-floor(iO/100)<0.005
%                close 
%            end       
        end  
        
   end
   
    
end

