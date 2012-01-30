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
%   3 vectors for the course of floating, flying and diving + 1 vector with the timestamps



% the bins to create the histograms with. Edges in now km/h
%bins = [0, 2, 4, 6, 8, 10, 14, 18, 22, 30, 38, 45, 60, 90, 9001]; 
bins = [0, 5, 10, 20, 40, 60, 120];
bins ./ 3.6;

m1Hist = createTrainingHist('floating', bins, histogramSizeSeconds, timestampStep);
m2Hist = createTrainingHist('flying', bins, histogramSizeSeconds, timestampStep);
m3Hist = createTrainingHist('diving', bins, histogramSizeSeconds, timestampStep);

dataPointsPerHist = sum(m1Hist);
halvedDataPointsPerHist = round(dataPointsPerHist/2)

m1Course = zeros(size(interpolatedTimestamps, 1)-dataPointsPerHist, 1);
m2Course = zeros(size(interpolatedTimestamps, 1)-dataPointsPerHist, 1);
m3Course = zeros(size(interpolatedTimestamps, 1)-dataPointsPerHist, 1);


timestamps = interpolatedTimestamps(halvedDataPointsPerHist:size(interpolatedTimestamps, 1)-halvedDataPointsPerHist);



for x = halvedDataPointsPerHist + 1 : size(interpolatedTimestamps) - halvedDataPointsPerHist 
    % create histogram of moment
    speedsOfMoment = interpolatedSpeeds(x-halvedDataPointsPerHist:x+halvedDataPointsPerHist);
    histOfMoment = histc(speedsOfMoment, bins);
    % compare hists
    sum(histOfMoment)
    sum(m1Hist)
    m1Dif = sum(abs(histOfMoment - m1Hist));
    m2Dif = sum(abs(histOfMoment - m2Hist));
    m3Dif = sum(abs(histOfMoment - m3Hist));

    % safe! (in percentage corresponding to) 
    m1Course(x-halvedDataPointsPerHist, 1) = 100 - ((m1Dif / (dataPointsPerHist*2)) * 100);
    m2Course(x-halvedDataPointsPerHist, 1) = 100 - ((m2Dif / (dataPointsPerHist*2)) * 100);
    m3Course(x-halvedDataPointsPerHist, 1) = 100 - ((m3Dif / (dataPointsPerHist*2)) * 100); 
end










