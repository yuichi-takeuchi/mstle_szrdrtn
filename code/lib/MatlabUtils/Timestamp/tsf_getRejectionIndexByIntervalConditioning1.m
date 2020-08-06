function [ rejectionIndex ] = tsf_getRejectionIndexByIntervalConditioning1( srcRiseFallMat, rejectDrtn, sr, polarFlag)
%
% This function returns an index vector for timestamp rejection 
% 
% Usage:
%   [ rejectionIndex ] = tsf_getRejectionIndexByIntervalConditioning1( srcRiseFallMat, rejectDrtn, sr, polarFlag)
%
% INPUTS:
%    srcRiseRallMat (uint64 matrix): (event x rise and fall timestamp pair)
%    rejectDrtn (scalar): duration in second for rejection
%    sr (scalar): sampling rate
%    polarFlag (boolean): true for rejection lager interval than
%    rejectDrtn, false for rejection smaller interval than rejectDrtn
% OUTPUT:
%    rejectionIndex: uint64, (event x rise and rall timestamp pair)
%
% Copyright (c) 2018, 2020 Yuichi Takeuchi
%

% Setting parameter
numpnts = floor(rejectDrtn * sr);
lngth = size(srcRiseFallMat,1);
index = 1:lngth-1;

% Exception
if lngth <= 1
    rejectionIndex = [];
    return
end

% Main process
if(polarFlag)
    rejectionIndex = find(srcRiseFallMat(index+1,1)-srcRiseFallMat(index,2) > numpnts);
else
    rejectionIndex = find(srcRiseFallMat(index+1,1)-srcRiseFallMat(index,2) < numpnts);
end



