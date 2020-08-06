function [TrueIndCellArray, RisingInd, FallingInd] = ssf_FindConsecutiveTrueChunks(srcLogicalVector)
%
% [TrueTSCellArray, RisingTS, FallingTS] = ssf_FindConcecutiveTruesChunks(srcLogicalVector)
%
% srcLogicalVector: like [0 0 0 0 1 1 1 1 0 0 1 1 0 0 1 1 1 1 0 0], logical
% or int16, double
% TrueIndCellArray: cell array of true chunks
% RisingInd: indexes of rising edges
% FallingInd: indexes of falling egdes
%
% Copyright (C) 2017, 2018 Yuichi Takeuchi 
%

TrueIndex = find([0 srcLogicalVector] ~= 0);
RisingInd = TrueIndex(diff([0 TrueIndex]) > 1)-1; 
if any(RisingInd)
    FallingInd = [TrueIndex(diff(TrueIndex) > 1) TrueIndex(end)]-1;
else
    FallingInd = [];
end

indRjct = RisingInd == FallingInd;
RisingInd(indRjct) = [];
FallingInd(indRjct) = [];
if any(RisingInd)
for i = 1:length(RisingInd)
    TrueIndCellArray{i} = RisingInd(i):FallingInd(i);
end
else
    TrueIndCellArray = cell(0,0);
end