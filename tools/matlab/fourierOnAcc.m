function frequency = fourierOnAcc(AccData)
    % FOURIERONACC uses the accellerometer data to plot the fourier
    % analisys. 
    % TODO: Later this function should return some frequencie(s) that occur
    % most in the data.
    % (now returns maximum as frequency)
    % Input: N by Width array of Accellerometer data. N is the length, width is 
    % assumed to be the number of different accellerometer data points 
    % provided (usually 3: x, y, z).


    % From the matlab example: (http://www.mathworks.nl/help/techdoc/ref/fft.html)
    Fs = 20;            % Sampling frequency (Assumed as always 20Hz, because none of the
                        % f's in UVA_ACC_START_LIMITED are specified.
    L = size(AccData, 1);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(AccData,NFFT)/L
    f = Fs/2*linspace(0,1,NFFT/2+1);
    subplot(2, 1, 1);
    plot(AccData);
    title('Accellerometer Data')
    xlabel('time')
    ylabel('heavyness')


    % Plot single-sided amplitude spectrum.
    subplot(2, 1, 2)
    GoodY = 2*abs(Y(1:NFFT/2+1))
    plot(f,GoodY) 
    title('Single-Sided Amplitude Spectrum of Accellerometer Data')
    xlabel('Frequency (Hz)')
    ylabel('|AccData(f)|')
    frequency = find(f, max(GoodY))
