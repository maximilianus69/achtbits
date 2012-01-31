function plotAcc(Accel, timeStamp)
    % PLOTACC plots the accellerometer data of a certain time stamp
    % Plots the x-axis red, y-axis green, z-axis blue
    % Input: [ID, timeStamp, entry, x, y, z]
    % This is the same as our files are formatted
    Accel = Accel(find(Accel(:, 2) ==  timeStamp), :);
    
    hold on
    
    plot(Accel(:, 3), Accel(:, 4), 'LineWidth',1, 'color', 'r'); 
    plot(Accel(:, 3), Accel(:, 5), 'LineWidth',1, 'color', 'b'); 
    plot(Accel(:, 3), Accel(:, 6), 'LineWidth',1, 'color', 'g'); 
    
    hold off

