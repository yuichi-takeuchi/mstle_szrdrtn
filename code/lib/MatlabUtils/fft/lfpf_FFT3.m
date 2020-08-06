function [f, normpower] = lfpf_FFT3(Signal, Start, Duration, Fs, Whitening, Smooting, Plot)
%
% normalized, power
%
% [f, normpower] = lfpf_FFT3(Signal, Start, Duration, Fs, Whitening, Smooting, Plot)
%   Signal:     Signal matrix (timeseries, channels)
%   Start:      Starting point (s)
%   Duration:   Duration for analysis (s)
%   Fs:         Sampling frequency (Hz)
%   Whiteing:   1: On, 0: Off
%   Smooting:   1: On, 0: Off
%   Plot:       1: On, 0: Off
%   f:          frequency
%   normpower:  normalirzed power
%
% Copyright (c) 2016 Yuichi Takeuchi
%

nChannels = size(Signal,2);
S = Signal((Fs*Start+1):Fs*(Start+Duration),:);
nfft = pow2(nextpow2(length(S)));  % Transform length
NumUniquePts = ceil((nfft+1)/2);
Y = fft(S,nfft);
absY = abs(Y(1:NumUniquePts,:));
f = (0:NumUniquePts-1)*Fs/nfft;
power = absY.*conj(absY)/nfft;

if rem(nfft,2)
    power(2:end) = power(2:end);
else
    power(2:end -1) = power(2:end -1);
end

if(Whitening)
    power = power.*repmat(f',1,size(power,2)); % whitening
end

if(Smooting)
    for i = 1:size(power, 2)
        power(:, i) = smooth(power(:,i)); % smoothing
    end
end

for k = 1:nChannels % normalization
    normpower(:,k) = power(:,k)./max(power(:,k));
end

% % interporation
% vx = 0:floor((nfft+1)/2);
% powerSpectrum1 = interp1(f,powerSpectrum1,vx);
% f = vx;

if(Plot)
    plot(f,normpower)
end