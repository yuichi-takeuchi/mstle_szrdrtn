function [ hs ] = plotf_TimeFreqImage1( t, f, data, fignum, hax, nrmlzres )
% plots time-frequency image plot 
%
% Usage:
% [ hs ] = plotf_TimeFreqImage1( t, f, data, fignum, hax, nrmlzres )
% Input: 
%   t: time in second
%   f: frequency in Hz
%   data: f x t, normalized at color resolution
%   fignum: number of a target figure
%   hax: handle of the target axis
%   nrmlzres: resolution for normalization 
% Output:
%   hs: strucure of handles
%   
% Copyright (C) Yuichi Takeuchi 2018

hfig = figure(fignum);
hcm = colormap(jet(nrmlzres));

him = imagesc(t,f,data);
axis xy;
caxis([0 nrmlzres/1]);

hylabel = ylabel('');
hxlabel = xlabel('');
htitle = title('');

% building handle structure
hs.hfig = hfig;
hs.hax = hax;
hs.him = him;
hs.hylabel = hylabel;
hs.hxlabel = hxlabel;
hs.title = htitle;
hs.hcm = hcm;

end

