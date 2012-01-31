function result = testClustering()
% Runs 'main.m' a couple of times with different values that are known
% to be troublesome cases. Every exception should be shown with those
% values. 

% 9, 11, 12 

for x = 1:15
    main('344', x);
    uiwait;
end
%main('344', 5);
%pause;
%main('344', 9);
%pause;
%main('344', 12);
%pause;
