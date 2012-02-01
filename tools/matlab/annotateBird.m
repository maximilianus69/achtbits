function [ output_args ] = annotateBird( deviceId, annotationType, startSessionId )
%ANNOTATEBIRD starts annotation of all sessions of given device
%   INPUT:
%   deviceId - ID number of the device as a string
%   annotationType - determines if annotation is test ('test' or 'real')
%                       (this is used to determine the target directory)
%   startSession(optional, default:0) - ID of starting session, integer 
%   
%   checks if there are sessions for this device
%   loops through all sessions and calls annotateSession
%
%   writes to file:
%   
%   clusterFeatures - features and class per cluster (row)
%   path: tools/device_DEVICEID/ANNOTATIONTYPE/...
%       device_DEVICEID_session_SESSIONID_clusterFeatures.csv

addpath('plot');
format long;

if nargin < 3
    sessionId = 0;
else
    sessionId = startSessionId;
end


folderPath = strcat('../parsedCsvFiles/device', deviceId);
type = exist(folderPath);

% check if there is data for this bird ID
if type  == 7
    % open an annotation folder for bird
    % for each session in the folder:
    %   - open an annotation folder for session
    %   - run annotateSession
    
    if annotationType == 'real'
        outputDeviceFolder = strcat('../annotatedData/real/device_', deviceId);
        fprintf(strcat('starting real annotation session','\n', 'saving to folder:', outputDeviceFolder))
    elseif annotationType == 'test'
        outputDeviceFolder = strcat('../annotatedData/test/device_', deviceId);
        fprintf(strcat('starting test annotation session','\n', 'saving to folder:', outputDeviceFolder, '\n'))
    else
        fprintf('please enter "test" or "real" as second argument')
        return
    end
    
    
    if exist(outputDeviceFolder, 'dir') ~= 7
        mkdir(outputDeviceFolder);
    end
    
    inputFilePrefix = strcat('/device_', deviceId, '_gps_session_');
    
    sessionFilePath = strcat(folderPath, inputFilePrefix, sprintf('%03d', sessionId), '.csv');
    
    while exist(sessionFilePath) == 2
        
        fprintf(strcat('\n','starting annotation for session_', sprintf('%03d', sessionId), '\n'))
        stopAnnotation = annotateSession(deviceId, sessionId, outputDeviceFolder);
        
        if stopAnnotation
            close all
            fprintf(strcat('exiting tool\n'))
            return
        else
            fprintf(strcat('saving session_', sprintf('%03d', sessionId),' to file \n'))
        end
        
        sessionId = sessionId + 1;
        
        sessionFilePath = strcat(folderPath, inputFilePrefix, sprintf('%03d', sessionId), '.csv');
    end
    
    fprintf(strcat('no more sessions found for ', folderPath))
    
else
    
    fprintf(strcat('the folder ', folderPath, 'could not be found'))
end

close all;

end

