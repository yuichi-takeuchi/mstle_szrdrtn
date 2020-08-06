function filtf_LowPassButter1(srcName, destName, nChannels, varargin) 
%
% default
% filtf_LowPassButter1(srcName, destName, nChannels)
% <optional>
% filtf_LowPassButter1(srcName, destName, nChannels, lowpasscutoff, lowpassorder, fs)
% fs = sampling frequency
%
% INPUTS:
%    srcName: Name string of source dat file (eg. 'source.dat')
%    destName: Name string of destination dat file (eg. 'destination.dat')
%    nChannels: Total number of channels in the source dat file
%
% Copyright (C) 2017, 2020 Yuichi Takeuchi

[lowpasscutoff, lowpassorder, fs] = DefaultArgs(varargin, {300, 3, 2e4});
nyquistfreq = fs/2;
d = designfilt('lowpassiir','DesignMethod','butter', ...
        'FilterOrder',lowpassorder,'HalfPowerFrequency',lowpasscutoff/nyquistfreq);

infoFile = dir(srcName);
nSamples = floor(infoFile.bytes/(nChannels*2));
fid = fopen(destName, 'w');
fwrite(fid, zeros(1, nSamples*nChannels, 'int16'), 'int16');
fclose(fid);

m1 = memmapfile(destName, 'Format', 'int16', 'Writable', true);
m2 = memmapfile(srcName, 'Format', {'int16', [nChannels nSamples], 'x'});

for i = 1:nChannels
    fprintf('%d/%d channels\n', i,nChannels)
    DataSingleCh = m2.Data.x(i,:);
    DataSingleCh = filtfilt(d, double(DataSingleCh));
    m1.Data(i:nChannels:end) = DataSingleCh;
end
