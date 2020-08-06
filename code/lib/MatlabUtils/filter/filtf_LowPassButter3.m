function [DataOut] = filtf_LowPassButter3(DataIn, varargin)
%
% default
% [DataOut] = filtf_LowPassButter3(DataIn)
% <optional>
% [DataOut] = filtf_LowPassButter3(DataIn, lowpasscutoff, lowpassorder, fs)
% fs = sampling frequency
% DataIn: (channels, time series)
%
% (C) Yuichi Takeuchi 2016

[lowpasscutoff, lowpassorder, fs] = DefaultArgs(varargin, {300, 3, 2e4});
nyquistfreq = fs/2;
fNorm = lowpasscutoff / (fs /2);
[d,e] = butter(lowpassorder, fNorm, 'low');
   
% Starting...
% tic
disp('Low-pass filtering...')
% h = waitbar(0,'Low-pass filtering...');

for i = 1:size(DataIn, 1)
%     waitbar(i/size(DataIn, 1))
    DataOut(i,:) = filtfilt(d, e, double(DataIn(i,:)));
end

%Finishing info
% close(h)
disp('Low-pass filtering done.');
% toc
