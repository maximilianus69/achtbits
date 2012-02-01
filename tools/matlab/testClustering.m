function result = testClustering(session)
% Runs 'main.m' a couple of times with different values that are known
% to be troublesome cases. Every exception should be shown with those
% values. 

% 9, 11, 12 

if(nargin < 1)
    session = 0;
end

for x = session:15
    main('327', x);
    uiwait;
end
%main('344', 5);
%pause;
%main('344', 9);
%pause;
%main('344', 12);
%pause;
