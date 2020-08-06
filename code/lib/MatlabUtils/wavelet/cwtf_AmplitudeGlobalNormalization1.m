function [ wtscld, f, t ] = cwtf_AmplitudeGlobalNormalization1( data, sr, nrmlzres)
% continous wavelet time-frequency analysis with global normalization of
% power
%
% Usage:
% [ wt, f, t ] = cwtf_AmplitudeGlobalNormalization1( data, sr )
% Input: 
%   data: vector (double)
%   sr: sampling rate
%   nrmlzres: resolution for normalization 
% Output:
%   wtscld: f x t, normalized amplitude
%   f: frequency in Hz
%   t: time in second
%   
% Copyright (C) 2018 Yuichi Takeuchi

% wavelet analysis ()
[wt,f] = cwt(data, sr);
% wttemp = zscore(abs(wt).^2); % z-score normalization of wavelet power on each frequncy
wttemp = abs(wt)/max(abs(wt(:))); % linear normalization by max value over frequecny
wtscld = nrmlzres*wttemp;
t = 0:1/sr:(size(data,2)-1)/sr;

end

