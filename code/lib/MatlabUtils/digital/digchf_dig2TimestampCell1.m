function [ TSCell ] = digchf_dig2TimestampCell1( digch )
%
% [ TSCell ] = digchf_dig2Timestamp1( digch )
%
% This function gives an index matrix for the three brain states of two rats from input
% logical vector matrix.
%
% INPUT:
%   digch: time series vector of a 4 bit digital channel
% OUTPUT:
%   TSCell: time * channel (logical matrix)
% 
% Copyright (C) 2018, 2020 Yuichi Takeuchi
%

% Get binary vector
digBinaryVector = logical(decimalToBinaryVector(digch, 4, 'LSBFirst')); 

% Get timestamps and build a timestamp structure
for i = 4:-1:1
    [~,tempR,tempF] = ssf_FindConsecutiveTrueChunks(digBinaryVector(:,i)');
    tempRF = uint64([tempR' tempF']);
    TSCell{i} = tempRF;
end

% Save
% TSStruct = TSStruct(1:3);
% save([datfilenamebase '_1_Timestamp.mat'], 'TSStruct', '-v7.3')





