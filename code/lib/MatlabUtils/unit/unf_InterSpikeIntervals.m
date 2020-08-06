function [ISI] = unf_InterSpikeIntervals(Timestamp, BinSize, HalfBins)
%
% [ISI] = unf_CCGKS2Test(Timestamp, BinSize, HalfBins)
%
%   Timestamp: vector like .res.0 file
%   BinSize: number of sample
%   HalfBins: window = 2*HalfBins + 1 
%   ISI: interspike intervals 
%
% Copyright (C) 2017 Yuichi Takeuchi
%

Timestamp = double(Timestamp(:));
numpnts = length(Timestamp);
% size reduction
if(numpnts > 5000)
    Timestamp = Timestamp(randperm(numpnts,5000));
end
numpnts = length(Timestamp);

ISI = ones(numpnts,1)*Timestamp' - Timestamp*ones(1,numpnts);

for k = 1:numpnts
    ISI(k,k) = NaN;
end
ISI = ISI(ISI < BinSize*HalfBins & ISI > -3*BinSize*HalfBins);
ISI = ISI(:);
