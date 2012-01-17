function result = plot3d(FlightMatrix)
% plots a 3d flight in 2d with grey scale indicating height

% flight matrix: [id, time, x, y, z, speedx, speedy, speedz] x N
% (N = number of datapoints)

% used to normalize?
xs = FlightMatrix(3, :);
ys = FlightMatrix(4, :);
zs = FlightMatrix(5, :);
N = size(xs)(2);

maxValueX = max(xs);
maxValueY = max(ys);
maxValueZ = max(zs);

imageWidth = 200; % pixels 
imageHeight = 200; % pixels

xFactor = imageWidth / maxValueX;
yFactor = imageHeight / maxValueY;

% 'normalize' coordinates and z value
xs .* (imageWidth / maxValueX);
ys .* (imageHeight / maxValueY);
zs ./ maxValueZ;

image = zeros(imageWidth, imageHeight);

for i = 1:N
    image(xs(i), ys(i)) = zs(i);
end

