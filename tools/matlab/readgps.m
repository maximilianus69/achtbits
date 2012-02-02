function SessionGpsData = readgps( deviceId, sessionId )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

fileName = strcat('../parsedCsvFiles/device', deviceId, '/device_', ...
    deviceId, '_gps_session_', sprintf('%03d', sessionId), '.csv');

SessionGpsData = dlmread(fileName, ',');
end

