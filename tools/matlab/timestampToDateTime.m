function datetime = timestampToDateTime(timestamp);
% converts an achtbits timestamp (seconds since 01-01-2008)
% to a date time (via matlab datenum..)
%
% example of timestamp in datafile: 44549108 
% seconds removed from 1970 epoch: 1199142000 

timestamp = timestamp + 1199142000;


% because matlab can't use normal timestamps ....
datenumOffset = datenum(1970, 1, 1); % number of days from 1 jan 0 to epoch

% divide by number of seconds per day 
datenumNow = ((timestamp/60)/60)/24; % timestamp from seconds to days

datetime = datestr(datenumNow + datenumOffset);





