function [m1Course, m2Course, m3Course, timestamps] = histogramCompare(interpolatedTimestamps, interpolatedSpeeds, interpolatedXSpeed, interpolatedYSpeed, histogramSizeSeconds, timestampStep)
% compares 3 histogram models with each point in a session and returns, in percentages,
% how well the models fit over the course of the flight. 
%
% IN: 
%   interpolatedTimestamps, a vector of timestamps with each timestamp being timestampStep seconds apart from the next timestamp. 
%   interpolatedSpeeds, a vector of speeds that describe a birds speed in a session at a timestamp from interpolatedTimestamps. 
%   interpolatedXSpeed, the interpolated instantaneous x speed
%   interpolatedYSpeed, the interpolated instantaneous y speed
%   histogramSizeSeconds, the length of the histogram in seconds to work with
%   timestampStep, the amount of seconds between each timestamp
%
% OUT: 
%   3 vectors for the course of floating, flying and diving + 1 vector with the timestamps

% ability to weigh speed or angles differently from each other
speedFactor = 1;
angleFactor = 1;

% how many bins are in which histogram?
speedHistEntries = 0;
angleHistEntries = 0;


% the bins to create the histograms with. Edges in now km/h
%bins = [0, 2, 4, 6, 8, 10, 14, 18, 22, 30, 38, 45, 60, 90, 9001]; 
binsSpeed = [0, 5, 10, 20, 40, 60, 120];
binsSpeed ./ 3.6;

binsAngle = [0, 5, 10, 30, 60, 180, 360];

% create real histograms from models
[m1HistSpeed m1HistAngle] = createTrainingHist('floating', binsSpeed, binsAngle, histogramSizeSeconds, timestampStep);
[m2HistSpeed m2HistAngle] = createTrainingHist('flying', binsSpeed, binsAngle, histogramSizeSeconds, timestampStep);
[m3HistSpeed m3HistAngle] = createTrainingHist('diving', binsSpeed, binsAngle, histogramSizeSeconds, timestampStep);

% calculate data points for looping over session
dataPointsPerHist = sum(m1HistSpeed);
halvedDataPointsPerHist = floor(dataPointsPerHist/2);
odd = mod(dataPointsPerHist, 2) == 0;

% take into account the speed factor
m1HistSpeed .* speedFactor;
m2HistSpeed .* speedFactor;
m3HistSpeed .* speedFactor;

speedHistEntries = sum(m1HistSpeed);

angleHistEntries = sum(m1HistAngle);


m1Course = zeros(size(interpolatedTimestamps, 1)-dataPointsPerHist, 1);
m2Course = zeros(size(interpolatedTimestamps, 1)-dataPointsPerHist, 1);
m3Course = zeros(size(interpolatedTimestamps, 1)-dataPointsPerHist, 1);

% added this minus 1 @ random, could also remove that 1 from the beginning 
timestamps = interpolatedTimestamps(halvedDataPointsPerHist:size(interpolatedTimestamps, 1)-halvedDataPointsPerHist - 1); 


for x = halvedDataPointsPerHist + 1 : size(interpolatedTimestamps) - halvedDataPointsPerHist 
    % create histogram of moment (speed)
    speedsOfMoment = interpolatedSpeeds(x-halvedDataPointsPerHist:x+halvedDataPointsPerHist - odd);  
    histOfMomentSpeed = histc(speedsOfMoment, binsSpeed);
    histOfMomentSpeed .* speedFactor;

    % create histogram of moment for angle 
    xSpeedsOfMoment = interpolatedXSpeed(x-halvedDataPointsPerHist:x+halvedDataPointsPerHist-odd);
    ySpeedsOfMoment = interpolatedYSpeed(x-halvedDataPointsPerHist:x+halvedDataPointsPerHist-odd);

    % calculate the total rotation of the bird in degrees of this piece of flight
    totalVar = zeros(size(xSpeedsOfMoment));
    for i = 1:size(xSpeedsOfMoment, 1) - 1
        u = [xSpeedsOfMoment(i) ySpeedsOfMoment(i)];
        v = [xSpeedsOfMoment(i+1) ySpeedsOfMoment(i+1)];
        cosTheta = dot(u,v)/(norm(u)*norm(v));
        totalVar(i) = acos(cosTheta)*180/pi;
    end
       
    histOfMomentAngle = histc(totalVar, binsAngle);
    histOfMomentAngle .* angleFactor;
    
   
    % compare hists
    m1DifSpeed = sum(abs(histOfMomentSpeed - m1HistSpeed));
    m2DifSpeed = sum(abs(histOfMomentSpeed - m2HistSpeed));
    m3DifSpeed = sum(abs(histOfMomentSpeed - m3HistSpeed));

    m1DifAngle = sum(abs(histOfMomentAngle - m1HistAngle));
    m2DifAngle = sum(abs(histOfMomentAngle - m2HistAngle));
    m3DifAngle = sum(abs(histOfMomentAngle - m3HistAngle));

    % safe! (in percentage corresponding to) 
    m1Course(x-halvedDataPointsPerHist, 1) = 100 - (((m1DifSpeed + m1DifAngle) / ((speedHistEntries+angleHistEntries)*2)) * 100);
    m2Course(x-halvedDataPointsPerHist, 1) = 100 - (((m2DifSpeed + m2DifAngle) / ((speedHistEntries+angleHistEntries)*2)) * 100);
    m3Course(x-halvedDataPointsPerHist, 1) = 100 - (((m3DifSpeed + m3DifAngle) / ((speedHistEntries+angleHistEntries)*2)) * 100);
end








