function result = testClustering()
% Runs 'main.m' a couple of times with different values that are known
% to be troublesome cases. Every exception should be shown with those
% values. 

main('344', 5);
pause;
main('344', 9);
pause;
main('344', 12);
%pause;
