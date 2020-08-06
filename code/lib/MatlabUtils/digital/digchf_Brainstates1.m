function [ outIndex ] = digchf_Brainstates1( digBinaryVector )
%
% [ outIndex ] = digchf_Brainstates1( digBinaryVector )
%
% This function gives index matrix for the three brain states from input
% logical vector matrix.
%
% INPUT:
%   digBinaryVector: time * channel (logical matrix)
% OUTPUT:
%   outIndex: time * channel (logical matrix)
% 
% Copyright (C) 2018 Yuichi Takeuchi
%

outIndex(:,1) = digBinaryVector(:,1) & digBinaryVector(:,3); % non-REM
outIndex(:,2) = digBinaryVector(:,3) & ~outIndex(:,1); % REM
outIndex(:,3) = ~digBinaryVector(:,3); % Awake


end

