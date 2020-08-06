function [ outIndex ] = digchf_Brainstates2( digBinaryVector )
%
% [ outIndex ] = digchf_Brainstates2( digBinaryVector )
%
% This function gives an index matrix for the three brain states of two rats from input
% logical vector matrix.
%
% INPUT:
%   digBinaryVector: time * channel (logical matrix)
% OUTPUT:
%   outIndex: time * channel (logical matrix)
% 
% Copyright (C) 2018 Yuichi Takeuchi
%

% rat1
outIndex(:,1) = digBinaryVector(:,1) & digBinaryVector(:,2); % non-REM
outIndex(:,2) = digBinaryVector(:,2) & ~outIndex(:,1); % REM
outIndex(:,3) = ~digBinaryVector(:,2); % Awake

% rat2
outIndex(:,4) = digBinaryVector(:,3) & digBinaryVector(:,4); % non-REM
outIndex(:,5) = digBinaryVector(:,4) & ~outIndex(:,4); % REM
outIndex(:,6) = ~digBinaryVector(:,4); % Awake

end

