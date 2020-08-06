function [DataOut] = filtf_HighPassButter3(DataIn, varargin) 
%
% default
% DataOut = filtf_HighPassButter3(DataIn)
% <optional>
% DataOut = filtf_HighPassButter3(DataIn, highpasscutoff, highpassorder, fs)
% fs = sampling frequency
% DataIn: (channels, time series)
%
% (C) Yuichi Takeuchi 2016

[highpasscutoff, highpassorder, fs] = DefaultArgs(varargin, {500, 3, 2e4});
nyquistfreq = fs/2;
fNorm = highpasscutoff / (fs /2);
[d,e] = butter(highpassorder, fNorm, 'high');

% Starting...
% tic
disp('High-pass filtering...')
% h = waitbar(0,'High-pass filtering...');

for i = 1:size(DataIn, 1)
%     waitbar(i/size(DataIn, 1))
    DataOut(i,:) = filtfilt(d, e, double(DataIn(i,:)));
end

% Finishing info
% close(h)
disp('High-pass filtering done.');
% toc
