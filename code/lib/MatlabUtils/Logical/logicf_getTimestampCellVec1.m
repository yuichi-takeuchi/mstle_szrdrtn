function [ TimestampCellVector ] = logicf_getTimestampCellVec1( LogicalMatrix, RejectionMatrix )
%
% This function returns a cell vector of rising and falling timestamps from
% logical matrix.
% 
% Usage:
%   [ TimestampCellVector ] = logicf_getTimestampCellVec1( LogicalMatrix, RejectionMatrix )
%
% INPUTS:
%    LogicalMatrix: Ch, Trial or Regions x Time index
%    RejectionMatrix: number of rejection segment x pair of time index 
%    nChannels: Total number of channels in the source dat file
% OUTPUT:
%    TimestampCellVector: Cell vector, each element of which contains
%    rising and falling time indexes
%
% Copyright (C) Yuichi Takeuchi 2018
%
TimestampCellVector = cell(1,size(LogicalMatrix,1));
for i = 1:size(LogicalMatrix,1)
    [~,tempR,tempF] = ssf_FindConsecutiveTrueChunks(LogicalMatrix(i,:));
    for j = 1:size(RejectionMatrix, 1)
        index = tempR < RejectionMatrix(j,1) | tempR > RejectionMatrix(j,2);
        tempR = tempR(index);
        tempF = tempF(index);
    end
    TimestampCellVector{i} = uint64([tempR' tempF']);
end


