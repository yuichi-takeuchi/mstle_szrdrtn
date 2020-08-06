function [FiringRateMat] = unf_CalcFiringRateTimecourse(CluVec,Timestamp,CluID,npnts,sr,binwidth)
%
% unf_CalcFiringRateTimecourse calculates firing rate of each cluster
% along timecouse
%
% INPUTS:
%    CluVec: vector like .clu.0 file but without total no. cluster
%    Timestamp: vector like .res.0 file
%    CluID = ID of Clusters, scalar or vector
%    npnts = total sampling points of each ch.
%    sr = sampling rate
%    binwidth (s)
%
% OUTPUT:
%    FiringRateMat: Firing rate Matrix of specified Clusters along
%    timecourse
%       
% Copyright (C) 2016 Yuichi Takeuchi
%

binsize = floor(binwidth*sr);
for l = 1:floor(npnts/binsize)
    index1 = Timestamp >= ((l-1)*binsize +1);
    index2 = Timestamp <= l*binsize;
    index3 = and(index1, index2);
    TSinWin = Timestamp(index3);
    CluVecinWin = CluVec(index3);
    for k = 1:length(CluID)
        Spkts = TSinWin(CluVecinWin == CluID(k));
        FiringRateMat(l,k) = numel(Spkts)*sr/binsize;
    end
end