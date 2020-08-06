function [ DataOut ] = fileiof_getSegmentFromBinary1( srcName, Segment, nChannels )
%
% This function extract a defined segment from a binary fie (e.g., dat) and
% returns a extracted matrix.
% 
% Usage:
%   [ DataOut ] = fileiof_getSegmentFromBinary1( srcName, Segment, nChannels )
%
% INPUTS:
%    srcName: Name string of source dat file (eg. 'source.dat')
%    Segment: index vectors of the begining and the end. e.g. [1001 2000]
%    nChannels: Total number of channels in the source dat file
% OUTPUT:
%    DataOut: Int16 output variable
%
% Copyright (c) 2018 Yuichi Takeuchi
%

infoFile = dir(srcName);
nSamples = floor(infoFile.bytes/(nChannels*2));
m = memmapfile(srcName,'Format', {'int16', [nChannels nSamples], 'x'});
Period = Segment(1):Segment(2);
% disp('retrieving the data segment...')
DataOut(:,Period-Segment(1)+1) = m.Data.x(:,Period);
% disp('done')




