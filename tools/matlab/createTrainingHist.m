function Hist = createTrainingHist(type, bins, length, timeStep)
    % CREATETRAININGHIST: Creates a histogram of one of the following types:
    % 'flying', 'diving', 'floating'
    % Input: 
    %       type: the type of example you want to use. There should be an example file
    %             with the name <type>Example.csv 'flying, 'diving' or 'floating'
    %       bins: An array of bins that you want to make your histogram with
    %       length (optional): the time (in seconds) this histogram should take, defaults to 1200 seconds
    %               which is 20 minutes.
    %       timeStep (optional): The time that should be between two points, in seconds. Defaults to 
    %               150 seconds (2.5 minutes).

    if(nargin < 4)
        timeStep = 150;
        if(nargin < 3)
            length = 1200;
        end
    end
    
    % Get the data
    file = strcat('examples/', type, 'Example.csv');
    Data = dlmread(file, ',');
    Input = getTimeAndSpeed(Data);
    
    % Get time and speed
    Time = Input(:, 1);
    Time = Time - Time(1);
    for i = 1:size(Input, 1)
        Speed(i, :) = norm(Input(i, 2:3));
    end

    % Interpolate
    [RealTime RealSpeed] = interpolate(Time, Speed, timeStep);


    % Take length minutes of the Input vector

    % If the example file is too short
    while (size(RealSpeed, 1) <= length/timeStep)
        RealTime = [RealTime ; (RealTime + RealTime(size(RealTime, 1)) + timeStep)];
        RealSpeed = [RealSpeed;RealSpeed];
    end

    % If the example is too long:
    if(size(RealSpeed, 1) > length/timeStep)
        % Delete the last entries from RealTime
        RealTime((round(length/timeStep)+2):size(RealTime, 1), :) = [];
        % And RealSpeed
        RealSpeed((round(length/timeStep)+2):size(RealSpeed, 1), :) = [];
    end

    size(RealSpeed)

    subplot(2,1,1);
    plot(RealTime, RealSpeed);
    subplot(2, 1, 2);
    Hist = histc(RealSpeed, bins);
    bar(bins, Hist);
    % hist(RealSpeed, bins);


    
