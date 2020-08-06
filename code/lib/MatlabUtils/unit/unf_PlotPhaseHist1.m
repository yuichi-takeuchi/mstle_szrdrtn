function [ hstruct ] = unf_PlotPhaseHist1( SrcCount, binsize, maxdegree, strplotprop, Title)
%
% [ hstruct ] = unf_PlotPhaseHist1( SrcCount, binsize, maxdegree, strplotprop, Title))
%
%   SrcCount: Source count along 0-359 degree
%   binsize: in degree (eg. 20)
%   maxdegree: in degree (eg. 720)
%   strplotprop: string for phase line property (eg. '-b')
%   Title: string for title
%   
% Copyright (C) 2017 Yuichi Takeuchi
%

Count = sum(reshape(SrcCount,binsize,floor(360/binsize)));
Phase = linspace(0,2*pi*maxdegree/360,floor(maxdegree/binsize));
hold on;
hbar = bar(Phase,[Count Count],'facecolor','k','edgecolor','k');
yl = get(gca, 'YLim');
t = linspace(0, 2*pi*maxdegree/360, maxdegree);
stimwave = 0.25*yl(2)*sin(t + 1.5*pi) + 0.75*yl(2);
hplot = plot(t,stimwave,strplotprop);
hold off;
box off;
xlim([0 4*pi]);
% set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'XTick', linspace(0,4*pi,3))
set(gca, 'XTickLabel',{'0','2\pi','4\pi'}) % '2\pi'
htitle = title(Title);

hstruct.hbar = hbar;
hstruct.hplot = hplot;
hstruct.htitle = htitle;