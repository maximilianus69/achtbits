function [newTimeStamps newSpeedVector] = interpolate(timeStamps, speedVector, timeStep, method)
    % INTERPOLATE: interpolates values in the speedVector to return values
    % that are one timeStep away from each other. This should remove noise.
    % Input: timeStamps: a vertical vector of time stamps
    %        speedVector: a (same size as timeStamps) vertical vector of speeds
    %        timeStep (optional): the steps of time we should interpolate on (defaults to 2.5)
    %        method (optional): Interpolation method. Defaults to linear, can be:
    %            'nearest'
    %            Nearest neighbor interpolation
    %            'linear'
    %            Linear interpolation (default)
    %            'spline'
    %            Cubic spline interpolation
    %            'pchip'
    %            Piecewise cubic Hermite interpolation
    %            'cubic'
    %            (Same as 'pchip')
    %            'v5cubic'
    %            Cubic interpolation used in MATLAB 5. This method does not extrapolate. Also, if x is not equally spaced, 'spline' is used.v

    if (nargin < 4)
        method = 'linear';
        if(nargin < 3)
            timeStep = 150;
        end
    end

    newTimeStamps = (timeStamps(1):timeStep:timeStamps(size(timeStamps, 1)))';
    newSpeedVector = interp1(timeStamps, speedVector, newTimeStamps, method);
