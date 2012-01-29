function Hist = createTrainingHist(type, length, timeStep)
    % CREATETRAININGHIST: Creates a histogram of one of the following types:
    % 'flying', 'diving', 'floating'
    if(nargin < 3)
        timeStep = 150;
        if(nargin < 2)
            length = 1200;
        end
    end
    
    % Get the data
    file = strcat(type, 'Example.csv');
    Data = dlmread(file, ',');
    Input = getTimeAndSpeed(Data);
    
    % Get time and speed
    Time = Input(:, 1);
    Time = Time - Time(1);
    for i = 1:size(Input, 1)
        Speed(i, :) = norm(Input(i, 2:3));
    end
    [RealTime RealSpeed] = interpolate(Time, Speed, timeStep);
    % Take length minutes of the Input vector

    % If the example file is too short
    while (size(RealSpeed, 1) < length/timeStep)
        RealTime = [RealTime ; (RealTime + RealTime(size(RealTime, 1)) + timeStep)]
        RealSpeed = [RealSpeed;RealSpeed]
    end

    % If the example is too long:
    if(size(RealSpeed, 1) > length/timeStep)
        % Delete the last entries from RealTime
        RealTime((round(length/timeStep)+2):size(RealTime, 1), :) = []
        % And RealSpeed
        RealSpeed((round(length/timeStep)+2):size(RealSpeed, 1), :) = []
    end

    subplot(2,1,1);
    plot(RealTime, RealSpeed);
    bins = [0, 2, 4, 6, 8, 10, 14, 18, 22, 30, 38, 45, 60, 90]; 
    subplot(2, 1, 2);
    Hist = histc(RealSpeed, bins);
    bar(bins, Hist);
    % hist(RealSpeed, bins);


    
