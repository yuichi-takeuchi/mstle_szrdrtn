function [hstruct] = unf_ACG(CluVec,Timestamp,CluID,fignum, varargin)
%
% spf_SpikeAutoCorr plots AutoCorrelogram of specified 
%
% default
% [hstruct] = spf_SpikeAutoCorrelogram(CluVec,Timestamp,CluID,fignum)
% <optional>
% [hstruct] = 
% spf_SpikeAutoCorrelogram(CluVec,Timestamp,CluNo,fignum,windowwidth,binwidth)
%
% INPUTS:
%    CluVec: vector like .clu.0 file but without total no. cluster
%    Timestamp: vector like .res.0 file
%    CluNo: Cluster No.
%    windowwidth: histogram width (ms) (-windowwidth : +windowwidth)
%    binwidth: bin width (ms)
%
% Dependency:
%    Requires DefaultArgs function
%
% Copyright (C) 2016, 2017 Yuichi Takeuchi
%

% initialization values
[windowwidth,binwidth] = DefaultArgs(varargin, {30,0.5});

% Extract Spkts
Spkts = Timestamp(CluVec == CluID);

% size reduction
if(length(Spkts) > 20000)
    Spkts = Spkts(randperm(length(Spkts),20000));
end

% Timestamp in ms by /20
SpktsInms = double(Spkts)/20;

D = ones(length(SpktsInms),1)*SpktsInms' - SpktsInms*ones(1,length(SpktsInms));

for k = 1:length(SpktsInms)
    D(k,k) = NaN;
end

% Parameters
% fontname = 'Arial';
% fontsize = 10;

% making figure
hfig = figure(fignum);
    set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [1 1 9 6],...
    'NumberTitle','on'...
    );
%    'Name',['Cluster ' num2str(CluNo)]...

h = histogram(D,...
    'BinLimit',[-windowwidth,windowwidth],...
    'BinWidth',binwidth);
nbin = h.NumBins;
histogram(D,...
    'BinLimit',[-windowwidth,windowwidth],...
    'BinWidth',binwidth,...
    'NumBins',nbin+1);
hxlabel = xlabel('Time (ms)');
htitle = title(['Cluster ' num2str(CluID)]);
% haxes = gca;
% set(haxes,...
%     'FontName', fontname,...
%     'FontSize', fontsize...
%     );

hstruct.hfig = hfig;
% hstruct.haxes = haxes;
hstruct.hxlabel = hxlabel;
% hstruct.hylabel = hylabel;
hstruct.htitle = htitle;