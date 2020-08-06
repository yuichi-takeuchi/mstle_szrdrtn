function [ wtscld, f, t ] = cwtf_ZScorePowerAtEachFreq1( data, sr, nrmlzres)
% continous wavelet time-frequency analysis with global normalization of
% amplitude
%
% Usage:
% [ wtscld, f, t ] = cwtf_PowerZScoredAtEachFreq1( data, sr, nrmlzres )
% Input: 
%   data: vector (double)
%   sr: sampling rate
% Output:
%   wtscld: f x t, normalized power amplitude
%   f: frequency in Hz
%   t: time in second
%   
% Copyright (C) 2018 Yuichi Takeuchi

% wavelet analysis ()
[wt,f] = cwt(data, sr);
wtzpwr = zscore(abs(wt)).^2; % power of z-score normalization of wavelet amplitude on each frequncy
flngth = length(f);
wttemp(1:flngh,:) = wtzpwr(1:flngth, :)./max(wtzpwr(1:flngth,:));
wtscld = nrmlzres*wttemp;
t = 0:1/sr:(size(data,2)-1)/sr;

end

