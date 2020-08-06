function [freq,freqspect,Time] = lfpf_prepDataFFT2(Signal, Fs, TimeWindow, Overlap)
%
% [freq,freqspect,Time] = lfpf_prepDataFFT2(Signal, Fs, TimeWindow, Overlap)
% Signal:       (time series data x channels)
% Fs:           sampling frequency (Hz)
% TimeWindow:   width of slicing window (s)
% Overlap:      overlap of sliding window (between 0 and 1)
%   
% Copyright (c) 2016, 2017 Yuichi Takeuchi
%

nSamples = size(Signal,1);
nChannels = size(Signal,2);
WinLength = floor(TimeWindow*Fs);
nOverlap = floor(WinLength*Overlap);
winstep = WinLength - nOverlap;
nFFTChunks = round(((nSamples-WinLength)/winstep));
n = pow2(nextpow2(WinLength));  % Transform length
plength = ceil((n+1)/2);
freqspect = zeros(plength, nFFTChunks, nChannels);
Time = (0:(nFFTChunks-1))*winstep/Fs;

tic
h = waitbar(0);
for k = 1:nFFTChunks
    waitbar(k/nFFTChunks)
   [freq, power] = lfpf_FFT2(Signal, k*winstep/Fs, TimeWindow, Fs, 1, 1, 0);
   for l = 1:nChannels
       freqspect(:,k,l) = power(:,l);
   end
end
close(h)
toc
