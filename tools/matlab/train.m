function out = train( deviceId )
%TRAIN perform machine learning on data
%
% deviceId: string with the annotated device id
% method: learning method (TODO)


Features = createFeatureMatrix(deviceId);
svmtrain(Features(:,1:end-1), [ones(size(Features,1)-1,1);8]);

featureNames = {'duration', 'avgSpeed',   ...
    'heightDiff', 'grndDist', 'totDist', 'angleVar',       'previousCluster'};
behaviourClasses = {'unknown', 'sleeping', 'digesting', 'flying',...
        'diving', 'bad cluster'};

Names = cell(size(Features,1),1);
for i=1:size(Features,1)
    Names(i) = behaviourClasses(Features(i,end)); 
end

categorial = [7];
t = classregtree(Features(:,1:end-1), Names, 'categorical', categorial, 'names', featureNames);
view(t);

end
