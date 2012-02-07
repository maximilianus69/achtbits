function SessionAccData = readAcc( deviceId, sessionId )
    %READACC reads the acceleration data from file
    %   INPUT:
    %   deviceId - deviceId as string
    %   sessionid - sessionId as integer
    %
    %   OUPUT:
    %   [deviceId timeStamp entryId xAcc yAcc zAcc]

    SessionAccData = [];

    fileName = strcat('../parsedCsvFiles/device', deviceId, '/device_', ...
        deviceId, '_accel_session_', sprintf('%03d', sessionId), '.csv');

        if exist(fileName)
            SessionAccData = dlmread(fileName);
        end

    end

