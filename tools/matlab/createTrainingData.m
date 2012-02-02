function AllFeatures = createTrainingData
%CREATE_TRAINING_DATA first loads all csv files from all devices in the selected folder
% then makes the data WEKA friendly

% The indices of the features to extract from cluster data
% Cluster format: 
%   [id, startTime(s), endTime(s), duration(s), avgSpeed(km/h), ...
%    heightDiff(m), grndDist(km), totDist(km), angleVar(deg/s), ...
%    distDiff(m), resolution(dat/min), fx(Hz), fy(Hz), fz(Hz), ...
%	 previousCluster(int), annotation(int)]
neededFeatures = [4:16];

% get folder
folder = uigetdir('../', 'Select folder with that contains the annotated data folders'); 

% listing struct of bird dir
birdListing = dir(folder);

AllFeatures = [];

% This loops checks for 'device_*' directories, and appends the contents of '*clusterFeature.csv'
% files in those directories.
for d = 1:length(birdListing)
	% only open directories
	if birdListing(1).isdir
		birdDir = fullfile(folder, birdListing(d).name);

		% only open device folders
		if strfind(birdDir, 'device_')
			
			sessionListing = dir(birdDir);

			for s = 1:length(sessionListing)
				% only open files
				if ~sessionListing(s).isdir
					sessionFile = fullfile(birdDir, sessionListing(s).name);

					% check if filename is legal
					if strfind(sessionFile, 'clusterFeatures.csv')
						% load session data
						SessionData = dlmread(sessionFile, ',');
						AllFeatures = [AllFeatures; SessionData(:,neededFeatures)];
					end
				end
			end
		end
	end
end

% make WEKA friendly

behaviourClasses = {'unknown', 'sleeping', 'digesting', 'flying',...
        'diving', 'bad cluster'};

% remove all unknown and bad cluster examples
unknownId = find(strcmp(behaviourClasses,'unknown'));
badId = find(strcmp(behaviourClasses,'bad cluster'));
removeRows = find(ismember(AllFeatures(:,end), [unknownId badId]));
AllFeatures(removeRows,:) = [];

% save to file
labels = 'duration,avgSpeed,heightDiff,grndDist,totDist,angleVar,distDiff,resolution,fx,fy,fz,previousCluster,annotation';
dlmwrite(strcat(folder,'/AllFeatures.csv'), labels, '');
dlmwrite(strcat(folder,'/AllFeatures.csv'), AllFeatures,'-append');

% legend for class names
behaviourLabels = cellstr(cell2mat(strcat(behaviourClasses,',')))
dlmwrite(strcat(folder,'/classes.txt'), behaviourLabels, '');