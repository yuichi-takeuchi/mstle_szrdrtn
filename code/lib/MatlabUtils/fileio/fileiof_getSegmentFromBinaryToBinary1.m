function [flag] = fileiof_getSegmentFromBinaryToBinary1( srcName, Segment, Channels, nChannels, destName )
%
% INPUTS:
%    srcName: Name string of source dat file (eg. 'source.dat')
%    Segment: index vectors of the begining and the end. e.g. [1001 2000]
%    Channels: Channels to get
%    nChannels: Total number of channels in the source dat file
%    destName: Name string of destination dat file (eg. 'destination.dat')
%
% Copyright(c) 2019, 2020 Yuichi Takeuchi
%

flag = 0;

infoFile = dir(srcName);
nSamples = floor(infoFile.bytes/(nChannels*2));
m = memmapfile(srcName,'Format', {'int16', [nChannels nSamples], 'x'});
ind = 1:numel(Channels);
Period = Segment(1):Segment(2);
% disp('retrieving the data segment...')
srcVar(ind,Period-Segment(1)+1) = m.Data.x(Channels(ind),Period);
% disp('done')

% Starting information
fprintf('Writing %s\n', destName)
disp('Starting segment extraction...');

% Open input file and output file
fid = fopen(destName,'w');
fwrite(fid,srcVar,'int16');
fclose(fid);

% Finishing info
disp('Segment extraction Done.');
flag = 1;
