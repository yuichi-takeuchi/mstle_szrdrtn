function [hstruct] = unf_CCG_CalcPlot(CluVec,Timestamp,CluID1,CluID2, fignum,varargin)
%
% spf_SpikeCrossCorr plots CrossCorrelogram of specified 
%
% default
% [hstruct] = spf_SpikeCrossCorr(CluVec,Timestamp,CluID1,CluID2,fignum)
% <optional>
% [hstruct] = 
% spf_SpikeAutoCorrelogram(CluVec,Timestamp,CluID1,CluID2,fignum,windowwidth,binwidth)
%
% INPUTS:
%    CluVec: vector like .clu.0 file but without total no. cluster
%    Timestamp: vector like .res.0 file
%    CluID1, 2: Cluster ID.
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
Spkts1 = Timestamp(CluVec == CluID1);
Spkts2 = Timestamp(CluVec == CluID2);

% size reduction
if(length(Spkts1) > 20000)
    Spkts1 = Spkts1(randperm(length(Spkts1),20000));
end
if(length(Spkts2) > 20000)
    Spkts2 = Spkts2(randperm(length(Spkts2),20000));
end

% Timestamp in ms by /20
SpktsInms1 = double(Spkts1)/20;
SpktsInms2 = double(Spkts2)/20;

D = ones(length(SpktsInms2),1)*SpktsInms1' - SpktsInms2*ones(1,length(SpktsInms1));

% making figure
hfig = figure(fignum);
    set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [7 7 12 9],...
    'NumberTitle','on'...
    );

h = histogram(D,...
    'BinLimit',[-windowwidth,windowwidth],...
    'BinWidth',binwidth);
nbin = h.NumBins;
histogram(D,...
    'BinLimit',[-windowwidth,windowwidth],...
    'BinWidth',binwidth,...
    'NumBins',nbin+1);
hxlabel = xlabel('Time(ms)');
htitle = title(['Clu' num2str(CluID1) ' -> Clu' num2str(CluID2)]);

hstruct.hfig = hfig;
% hstruct.haxes = haxes;
hstruct.hxlabel = hxlabel;
% hstruct.hylabel = hylabel;
hstruct.htitle = htitle;
