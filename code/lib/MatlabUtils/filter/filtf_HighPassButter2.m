function filtf_HighPassButter2(srcName, destName, nChannels, varargin) 
%
% default
% filtf_HighPassButter2(srcName, destName, nChannels)
% <optional>
% filtf_HighPassButter2(srcName, destName, nChannels, highpasscutoff, highpassorder, fs)
% fs = sampling frequency
%
% INPUTS:
%    srcName: Name string of source dat file (eg. 'source.dat')
%    destName: Name string of destination dat file (eg. 'destination.dat')
%    nChannels: Total number of channels in the source dat file
%
% (C) Yuichi Takeuchi 2017

[highpasscutoff, highpassorder, fs] = DefaultArgs(varargin, {500, 3, 2e4});
nyquistfreq = fs/2;
fNorm = highpasscutoff / (fs /2);
[d,e] = butter(highpassorder, fNorm, 'high');

% Starting...
tic
disp('High-pass filtering...')
h = waitbar(0,'High-pass filtering...');

infoFile = dir(srcName);
nSamples = floor(infoFile.bytes/(nChannels*2));
fid = fopen(destName, 'w');
fwrite(fid, zeros(1, nSamples*nChannels, 'int16'), 'int16');
fclose(fid);

m1 = memmapfile(destName, 'Format', 'int16', 'Writable', true);
m2 = memmapfile(srcName, 'Format', {'int16', [nChannels nSamples], 'x'});

for i = 1:nChannels
    waitbar(i/nChannels)
    DataSingleCh = m2.Data.x(i,:);
    DataSingleCh = filtfilt(d, e, double(DataSingleCh));
    m1.Data(i:nChannels:end) = DataSingleCh;
end

%Finishing info
close(h)
disp('High-pass filtering done.');
toc
