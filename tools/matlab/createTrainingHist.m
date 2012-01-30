function [SpeedHist, AngleHist] = createTrainingHist(type, binsSpeed, binsAngle, length, timeStep)
    % CREATETRAININGHIST: Creates a histogram of one of the following types:
    % 'flying', 'diving', 'floating'
    % Input: 
    %       type: the type of example you want to use. There should be an example file
    %             with the name <type>Example.csv 'flying, 'diving' or 'floating'
    %       binsSpeed: An array of binsSpeed that you want to make your histogram with
    %       length (optional): the time (in seconds) this histogram should take, defaults to 1200 seconds
    %               which is 20 minutes.
    %       timeStep (optional): The time that should be between two points, in seconds. Defaults to 
    %               150 seconds (2.5 minutes).
    % Output:
    %       two histograms, one of the current speeds and one of the current angle differences

    if(nargin < 6)
        timeStep = 150;
        if(nargin < 4)
            length = 1200;
        end
    end
    
    % Get the data
    file = strcat('examples/', type, 'Example.csv');
    Data = dlmread(file, ',');
    Input = getTimeAndSpeed(Data);
    
    % Get time and speeds
    Time = Input(:, 1);
    Time = Time - Time(1);
    for i = 1:size(Input, 1)
        Speed(i, :) = norm(Input(i, 2:3));
    end
    InstSpeed = Data(:, 9:10);


    


    % Interpolate
    [RealTime RealSpeed] = interpolate(Time, Speed, timeStep);
    [RealXTime RealXSpeed] = interpolate(Time, Data(:, 9), timeStep);
    [RealYTime RealYSpeed] = interpolate(Time, Data(:, 10), timeStep);



    % Take length minutes of the Input vector

    % If the example file is too short
    while (size(RealSpeed, 1) <= length/timeStep)
        RealTime = [RealTime ; (RealTime + RealTime(size(RealTime, 1)) + timeStep)];
        RealSpeed = [RealSpeed;RealSpeed];
        RealXSpeed = [RealXSpeed;RealXSpeed];
        RealYSpeed = [RealYSpeed;RealYSpeed];
    end

    % If the example is too long:
    if(size(RealSpeed, 1) > length/timeStep)
        % Delete the last entries from RealTime
        RealTime((round(length/timeStep)+2):size(RealTime, 1), :) = [];
        % And RealSpeed
        RealSpeed((round(length/timeStep)+2):size(RealSpeed, 1), :) = [];
        RealXSpeed((round(length/timeStep)+2):size(RealXSpeed, 1), :) = [];
        RealYSpeed((round(length/timeStep)+2):size(RealYSpeed, 1), :) = [];
    end


    

    %totalVar = zeros(size(InstSpeed, 1) - 1);
    % Create angle histogram
    for i = 1:size(RealXSpeed, 1) - 1
        u = [RealXSpeed(i) RealYSpeed(i)];
        v = [RealXSpeed(i+1) RealYSpeed(i+1)];
        cosTheta = dot(u,v)/(norm(u)*norm(v));
        totalVar(i, :) = acos(cosTheta)*180/pi;
    end
    
    totalVar = totalVar
    AngleHist = histc(totalVar, binsAngle)
    %AngleHist .* angleFactor;

    %subplot(2,1,1);
    %plot(RealTime, RealSpeed);
    %subplot(2, 1, 2);
    SpeedHist = histc(RealSpeed, binsSpeed);
    %bar(binsSpeed, SpeedHist);
    % hist(RealSpeed, binsSpeed);


    
