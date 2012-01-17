function [ output_args ] = plotTrajectory( time, Coordinates, cluster )
%PLOTTRAJECTORY Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    cluster = [];
end

figure(1)

x = Coordinates(:, 1)
y = Coordinates(:, 2)

geoshow('netherlands_land.shp');
hold('on')

geoshow(x, y);

hold('off')
end

