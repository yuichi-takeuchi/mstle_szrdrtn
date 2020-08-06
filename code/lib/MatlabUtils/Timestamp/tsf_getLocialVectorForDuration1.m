function [ logicalVector ] = tsf_getLocialVectorForDuration1( timestamp, Length )
%
% This function returns an logical vector for timestamp rejection 
% 
% Usage:
%   [ logicalVector ] = tsf_getLocialVectorForDuration1( timestamp, Length )
%
% INPUTS:
%    timestampMatrix (uint64 matrix or vector):
%                    matrix, event x rise and fall timestamp
%    pair)
%    Length (integer): length of output logical vector
% OUTPUT:
%    logicalVector (logical)
%
% Copyright (c) 2018, 2020 Yuichi Takeuchi
%

if isempty(timestamp)
    logicalVector = [];
else
    timeIndex = 1:Length;
    transposed = timestamp';
    vectorized = transposed(:);
    logicalVector = timeIndex > vectorized(1) & timeIndex < vectorized(end);
end

