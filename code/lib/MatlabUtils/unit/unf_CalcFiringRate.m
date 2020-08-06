function [FiringRateVec] = unf_CalcFiringRate(CluVec,Timestamp,CluID,npnts,sr)
%
% unf_CalcFiringRate calculates firing rate of each cluster
% [FiringRateVec] = unf_CalcFiringRate(CluVec,Timestamp,CluID,npnts,sr)
% INPUTS:
%    CluVec: vector like .clu.0 file but without total no. cluster
%    Timestamp: vector like .res.0 file
%    CluID = ID of Clusters, scalar or vector
%    npnts = total sampling points of each ch.
%    sr = sampling rate
%
% OUTPUT:
%    FiringRateVec: Firing rate vector of specified Clusters 
%       
% Copyright (C) 2016 Yuichi Takeuchi
%

for k = 1:length(CluID)
    Spkts = Timestamp(CluVec == CluID(k));
    FiringRateVec(k) = numel(Spkts)*sr/npnts;
end



