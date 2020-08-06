function [ wtscld, f, t ] = cwtf_PowerGlobalNormalization1( data, sr, nrmlzres )
% continous wavelet time-frequency analysis with global normalization of
% amplitude
%
% Usage:
% [ wtscld, f, t ] = cwtf_PowerGlobalNormalization1( data, sr, nrmlzres )
% Input: 
%   data: vector (double)
%   sr: sampling rate
%   nrmlzres: resolution for normalization 
% Output:
%   wtscld: f x t, normalized power amplitude
%   f: frequency in Hz
%   t: time in second
%   
% Copyright (C) 2018 Yuichi Takeuchi

% wavelet analysis ()
[wt,f] = cwt(data, sr);
wttemp = abs(wt).^2/max(abs(wt(:)))^2; % linear normalization by max value over frequecny
wtscld = nrmlzres*wttemp;
t = 0:1/sr:(size(data,2)-1)/sr;

end

