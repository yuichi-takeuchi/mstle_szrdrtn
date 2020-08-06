function [f, power] = lfpf_FFT2(Signal, Start, Duration, Fs, Whitening, Smooting, Plot)
%
% power spectrum
%
% [f, power] = lfpf_FFT2(Signal, Start, Duration, Fs, Whitening, Smooting, Plot)
%   Signal:     Signal matrix (timeseries, channels)
%   Start:      Starting point (s)
%   Duration:   Duration for analysis (s)
%   Fs:         Sampling frequency (Hz)
%   Whiteing:   1: On, 0: Off
%   Smooting:   1: On, 0: Off
%   Plot:       1: On, 0: Off
%   f:          frequency
%   power:      power
%   
% Copyright (c) 2016 Yuichi Takeuchi
%

S = Signal((Fs*Start+1):Fs*(Start+Duration), :);
m = length(S);       %Window length
n = pow2(nextpow2(m));  % Transform length
plength = ceil((n+1)/2);
y = fft(S,n);           % DFT
f = (0:n-1)*(Fs/n);     % Frequency range
power = y.*conj(y)/n;   % Power of the DFT

f = f(1:plength);
power = power(1:plength,:);

if(Whitening)
    power = power.*repmat(f',1,size(power,2)); % whitening
end

if(Smooting)
    for i = 1:size(power, 2)
        power(:, i) = smooth(power(:,i)); % smoothing
    end
end

% interporation
% vx = 0:floor((n+1)/2);
% power = interp1(f,power,vx);
% f = vx;

if(Plot)
    plot(f,power)
%    xlim([0 100])
%    ylim([0 500])
%     ylim([0 1e8])   
    title('{\bf Periodogram}')
    xlabel('Frequency (Hz)')
    ylabel('Power')
end