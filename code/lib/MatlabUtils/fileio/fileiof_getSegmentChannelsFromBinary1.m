function [ DataOut ] = fileiof_getSegmentChannelsFromBinary1( srcName, Segment, Channels, nChannels )
%
% INPUTS:
%    srcName: Name string of source dat file (eg. 'source.dat')
%    Segment: index vectors of the begining and the end. e.g. [1001 2000]
%    Channels: Channels to get
%    nChannels: Total number of channels in the source dat file
% OUTPUT:
%    DataOut: Int16 output variable
%
% (c) Yuichi Takeuchi 2018
%

infoFile = dir(srcName);
nSamples = floor(infoFile.bytes/(nChannels*2));
m = memmapfile(srcName,'Format', {'int16', [nChannels nSamples], 'x'});
ind = 1:numel(Channels);
Period = Segment(1):Segment(2);
disp('retrieving the data segment...')
DataOut(ind,Period-Segment(1)+1) = m.Data.x(Channels(ind),Period);
disp('done')




