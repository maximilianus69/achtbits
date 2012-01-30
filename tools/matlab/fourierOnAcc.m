function frequency = fourierOnAcc(AccData, timeStamp)
    % FOURIERONACC uses the accellerometer data to plot the fourier
    % analisys. 
    % (now returns maximum as frequency)
    % Input: AccData = [iD, timeStamp, entry, x, y, z]
    %        timeStamp = the time stamp you want to access the accellerometerdata from.
    
    % Turn off the warning when there are no peaks found
    warning('off', 'signal:findpeaks:noPeaks');

    AccData = AccData(find(AccData(:, 2) ==  timeStamp), :);

    %{ Delete this if you would want a plot (TODO: Remove this before delivery)
    if 0
    % Plot the original
    subplot(2, 1, 1);
    plotAcc(AccData, timeStamp);
    title('The original accellerometer data');
    end
    %}

    AccDataRaw = AccData(:, 4:6);

    % From the matlab example: (http://www.mathworks.nl/help/techdoc/ref/fft.html)
    Fs = 20;            % Sampling frequency (Assumed as always 20Hz, because none of the
                        % f's in UVA_ACC_START_LIMITED are specified.
    L = size(AccDataRaw, 1);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of AccData
    Y = fft(AccDataRaw,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);

    % Plot single-sided amplitude spectrum.
    Y1 = Y(:, 1);
    Y2 = Y(:, 2);
    Y3 = Y(:, 3);
    GoodY1 = 2.*abs(Y1(1:NFFT./2+1));
    GoodY2= 2.*abs(Y2(1:NFFT./2+1));
    GoodY3 = 2.*abs(Y3(1:NFFT./2+1));
    %{ For plotting. TODO: Remove this when we are sure it works
    if 0
    subplot(2, 1, 2);
    plot(f,GoodY1);
    hold on
    plot(f, GoodY1, '-s','LineWidth',1, ...
                'MarkerEdgeColor','r', ...
                'MarkerFaceColor','auto', ...
                'MarkerSize',4); 
    plot(f, GoodY2, '-s','LineWidth',1, ...
                'MarkerEdgeColor','g', ...
                'MarkerFaceColor','auto', ...
                'MarkerSize',4); 
    plot(f, GoodY3, '-s','LineWidth',1, ...
                'MarkerEdgeColor','b', ...
                'MarkerFaceColor','auto', ...
                'MarkerSize',4); 
    title('Single-Sided Amplitude Spectrum of Accellerometer Data');
    xlabel('Frequency (Hz)');
    ylabel('|AccDataRaw(f)|');
    end
    %}
    % Find the peaks in the fourier 
    [values freq1] = findpeaks(GoodY1, 'MINPEAKHEIGHT', 0.2);
    [values freq2] = findpeaks(GoodY2, 'MINPEAKHEIGHT', 0.2);
    [values freq3] = findpeaks(GoodY3, 'MINPEAKHEIGHT', 0.2);
    % We need vertical vectors
    freq1 = freq1';
    freq2 = freq2';
    freq3 = freq3';
    sizes = [size(freq1, 1) size(freq2, 1) size(freq3, 1)];
    % Create the output matrix
    frequency = zeros(max(sizes), 3);
    frequency(1:size(freq2, 2), 1) = f(:, freq1)';
    frequency(1:size(freq2, 2), 2) = f(:, freq2)';
    frequency(1:size(freq3, 1), 3) = f(:, freq3)';
