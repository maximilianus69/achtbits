function out = train( deviceId, method )
%TRAIN perform machine learning on data
%
% Arguments:
% 	- deviceId: string with the annotated device id
% 	- method: learning method, ([i]tree[/i], svm)
%
% Currently only creates a decision tree.

% default is decision tree
if nargin < 2
	method = 'tree'
end

[Features, featureNames] = createFeatureMatrix(deviceId);

behaviourClasses = {'unknown', 'sleeping', 'digesting', 'flying',...
        'diving', 'bad cluster'};

if strcmp(method,'svm')
	svmtrain(Features(:,1:end-1), [ones(size(Features,1)-1,1);8]);
elseif strcmp(method, 'tree')
	Names = cell(size(Features,1),1);
	for i=1:size(Features,1)
	    Names(i) = behaviourClasses(Features(i,end)); 
	end

	categorial = find(strcmp(featureNames, 'prev_cluster'));
	t = classregtree(Features(:,1:end-1), Names, 'categorical', categorial, 'names', featureNames);
	view(t);
else
	print 'Method must be svm or tree!';
	return;
end