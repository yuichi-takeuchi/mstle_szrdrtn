function [f, amplitude] = lfpf_FFT1(Signal, Start, Duration, Fs, Whitening, Smooting, Plot)
%
% Single-Sided amplitude Spectrum
%
%   [f, amplitude] = lfpf_FFT1(Signal, Start, Duration, Fs, Whitening, Smooting, Plot)
%   Signal:     Signal matrix (timeseries, channels)
%   Start:      Starting point (s)
%   Duration:   Duration for analysis (s)
%   Fs:         Sampling frequency (Hz)
%   Whiteing:   1: On, 0: Off
%   Smooting:   1: On, 0: Off
%   Plot:       1: On, 0: Off
%   f:          frequency
%   amplitude:  amplitude matrix
%   
% Copyright (c) 2016, 2017 Yuichi Takeuchi
%

S = Signal((Fs*Start+1):Fs*(Start+Duration),:);
L = length(S);    % Length of signal
Y = fft(S);
P2 = 2*abs(Y/L);
amplitude = P2(1:L/2+1, :);
f = (0:(L/2))*Fs/L;

if(Whitening)
    amplitude = amplitude.*repmat(f',1,size(amplitude,2)); % whitening
end

if(Smooting)
    for i = 1:size(amplitude, 2)
        amplitude(:, i) = smooth(amplitude(:,i)); % smoothing
    end
end

if(Plot)
    plot(f,amplitude)
%     xlim([0 100])
%     ylim([0 500])   
    title('Single-Sided Amplitude Spectrum')
    xlabel('Frequency (Hz)')
    ylabel('Amplitude')
end