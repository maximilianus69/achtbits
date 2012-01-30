function [m1Course, m2Course, m3Course, timestamps] = histogramCompare(interpolatedTimestamps, interpolatedSpeeds, histogramSizeSeconds, timestampStep)
% compares 3 histogram models with each point in a session and returns, in percentages,
% how well the models fit over the course of the flight. 
%
% IN: 
%   interpolatedTimestamps, a vector of timestamps with each timestamp being timestampStep seconds apart from the next timestamp. 
%   interpolatedSpeeds, a vector of speeds that describe a birds speed in a session at a timestamp from interpolatedTimestamps. 
%   histogramSizeSeconds, the length of the histogram in seconds to work with
%   timestampStep, the amount of seconds between each timestamp
%
% OUT: 
%   3 vectors that describe how well each model fits the session at a certain point (is as long as the session - histogramSizeSeconds). 1, 2 and 3 represent the models. 4, 5, 6 represent the timestamps that belong to these courses.


dataPointsPerHist = histogramSizeSeconds/timestampStep;


% the bins to create the histograms with. Edges in now km/h
%bins = [0, 2, 4, 6, 8, 10, 14, 18, 22, 30, 38, 45, 60, 90, 9001]; 
bins = [0, 5, 10, 20, 40, 60, 120];
bins ./ 3.6;

% Create the histograms from the model here
m1Speeds = zeros(dataPointsPerHist, 1); % chillin'
m2Speeds = ones(dataPointsPerHist, 1); % crazy ass?
m3Speeds = ones(dataPointsPerHist, 1) .* 30; % flyin' 

m1Hist = histc(m1Speeds, bins);
m2Hist = histc(m2Speeds, bins);
m3Hist = histc(m3Speeds, bins);


m1Course = zeros(size(interpolatedTimestamps)-dataPointsPerHist, 1);
m2Course = zeros(size(interpolatedTimestamps)-dataPointsPerHist, 1);
m3Course = zeros(size(interpolatedTimestamps)-dataPointsPerHist, 1);
timestamps = interpolatedTimestamps(1 + dataPointsPerHist/2:size(interpolatedTimestamps)-dataPointsPerHist/2);



for x = (dataPointsPerHist/2) + 1 : size(interpolatedTimestamps) - dataPointsPerHist/2
    % create histogram of moment
    speedsOfMoment = interpolatedSpeeds(x-dataPointsPerHist/2:x+dataPointsPerHist/2);
    histOfMoment = histc(speedsOfMoment, bins);
    % compare hists
    m1Dif = sum(abs(histOfMoment - m1Hist));
    m2Dif = sum(abs(histOfMoment - m2Hist));
    m3Dif = sum(abs(histOfMoment - m3Hist));

    m1Dif
    %(m1Dif / (dataPointsPerHist*2)) * 100
   
    % safe! (in percentage corresponding to) 
    m1Course(x-dataPointsPerHist/2, 1) = 100 - ((m1Dif / (dataPointsPerHist*2)) * 100);
    m2Course(x-dataPointsPerHist/2, 1) = 100 - ((m2Dif / (dataPointsPerHist*2)) * 100);
    m3Course(x-dataPointsPerHist/2, 1) = 100 - ((m3Dif / (dataPointsPerHist*2)) * 100); 
end



plot(m2Course)







