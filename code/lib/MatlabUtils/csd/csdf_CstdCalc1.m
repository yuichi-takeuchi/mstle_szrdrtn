function [CSDMat] = csdf_CstdCalc1(LFPMat, Distance, nChannels)
%
%   LFPMat = timeseries x Channels
%   Distance = distance between channels (mm)
%   nChannels = number of channels
%
% Copyright (C) 2016 Yuichi Takeuchi

[nr, nc] = size(LFPMat);
CSDMat = zeros(nr,nc);

for k = 2:(nChannels-1)
   CSDMat(:,k) =  (LFPMat(:,(k-1)) - 2*LFPMat(:,k) + LFPMat(:,(k+1)))/Distance^2;
end
% CSDMat(:,1) = NaN;
% CSDMat(:,nChannels) = NaN;
% CSDMat(:,1) = CSDMat(:,2);
% CSDMat(:,nChannels) = CSDMat(:,nChannels-1);