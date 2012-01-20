function [ output_args ] = annotateBird( deviceId, startSession )
%ANNOTATEBIRD starts annotation of all sessions of given device
%   INPUT:
%   deviceId - ID number of the device as a string
%   startSession(optional, default:0) - ID of starting session, integer 
%   
%   checks if there are sessions for this device
%   loops through all sessions and calls annotateSession
%   writes to file:
%   sessionData - data of every data point in session from readgps
%   path: tools/deviceDEVICEID/session_SESSIONID/...
%       device_DEVICEID_session_SESSIONID_sessiondata.csv
%   
%   clusterFeatures - features and class per cluster (row)
%   path: tools/deviceDEVICEID/session_SESSIONID/...
%       device_DEVICEID_session_SESSIONID_clusterFeatures.csv

addpath('plot');

if nargin < 2
    sessionId = 0;
else
    sessionId = startSession;
end


folderPath = strcat('../parsedCsvFiles/device', deviceId);
type = exist(folderPath);

% check if there is data for this bird ID
if type  == 7
    % open an annotation folder for bird
    % for each session in the folder:
    %   - open an annotation folder for session
    %   - run annotateSession
    
    outputDeviceFolder = strcat('../annotatedData/device_', deviceId);
    
    if exist(outputDeviceFolder, 'dir') ~= 7
        mkdir(outputDeviceFolder);
    end
    
    inputFilePrefix = strcat('/device_', deviceId, '_gps_session_');
    
    sessionFilePath = strcat(folderPath, inputFilePrefix, sprintf('%03d', sessionId), '.csv');
    
    while exist(sessionFilePath) == 2
        
        sprintf(strcat('starting annotation for session_', sprintf('%03d', sessionId)));
        annotateSession(deviceId, sessionId, outputDeviceFolder);
        
        sessionId = sessionId + 1;
        
        sessionFilePath = strcat(folderPath, inputFilePrefix, sprintf('%03d', sessionId), '.csv');
    end
    
    sprintf(strcat('no more sessions found for ', folderPath))
    
else
    
    sprintf(strcat('the folder ', folderPath, 'could not be found'))
end

end

