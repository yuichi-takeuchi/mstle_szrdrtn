function [freq,freqspect,Time] = lfpf_prepDataFFT1(Signal, Fs, TimeWindow, Overlap)
%
%   [freq,freqspect,Time] = lfpf_prepDataFFT1(Signal, Fs, TimeWindow, Overlap)
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
freqspect = zeros((TimeWindow*Fs/2+1), nFFTChunks, nChannels);
Time = (0:(nFFTChunks-1))*winstep/Fs;
tic
h = waitbar(0);
for k = 1:nFFTChunks
    waitbar(k/nFFTChunks)
   [freq, amplitude] = lfpf_FFT1(Signal, k*winstep/Fs, TimeWindow, Fs, 1, 1, 0);
   for l = 1:nChannels
       freqspect(:,k,l) = amplitude(:,l);
   end
end
close(h)
toc