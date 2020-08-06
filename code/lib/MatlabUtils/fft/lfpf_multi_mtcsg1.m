function [yomat, fo, to] = lfpf_multi_mtcsg1(Signal, Fs, TimeWindow, Overlap)
%
% Preparing data for time-frequency time spectrogram using mtcsg().
% 
% [yomat, fo, to] = lfpf_multi_mtcsg1(Signal, Fs, TimeWindow, Overlap)
% Signal:       (time series data x channels)
% Fs:           sampling frequency (Hz)
% TimeWindow:   width of slicing window (s)
% Overlap:      overlap of sliding window (between 0 and 1)
%
% output yomat is yo(f, t, channels)
% fo:   frequency (Hz)
% to:   time (s)
%
% Copyright (c) 2016, 2017 Yuichi Takeuchi
%

nFFT = Fs;
WinLength = floor(TimeWindow*Fs);
nOverlap = floor(WinLength*Overlap);
winstep = WinLength - nOverlap;
nSamples = size(Signal,1);
nChannels = size(Signal,2);

% calculate number of FFTChunks per channel
nFFTChunks = round(((nSamples-WinLength)/winstep));

% set up f and t arrays
if ~any(any(imag(Signal)))    % x purely real
	if rem(nFFT,2),    % nfft odd
		select = [1:(nFFT+1)/2];
	else
		select = [1:nFFT/2+1];
	end
	nFreqBins = length(select);
end

% allocate memory now to avoid nasty surprises later
yomat = zeros(nFreqBins, nFFTChunks, nChannels);

tic
h = waitbar(0);
for k = 1:nChannels
    waitbar(k/nChannels)
    [yo, fo, to] = mtcsg(Signal(:,k),nFFT,Fs,WinLength,nOverlap,[],[],[],[]);  %do the multitaper spectrum analysis
    yomat(:,:,k) = yo;
end
close(h)
toc