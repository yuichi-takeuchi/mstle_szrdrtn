function [ hstruct ] = unf_CCG_PlotMeanGlbLcl1( t, CCGR, CCGMean, Global, Local, Title )
%
% [ hstruct ] = unf_CCG_PlotMeanGlbLcl1( t, CCGR, CCGMean, Global, Local, Title )
%
%   t: Time
%   CCGR: counts of events
%   CCGMean: Mean counts after jittering or shuffling 
%   Global: global significant lines after jittering or shuffling 
%   Local: local significant liens after jittering or shuffling 
%   Title: string for title
%   
% Copyright (C) 2017 Yuichi Takeuchi
%

hbar = bar(t,CCGR,'facecolor','k','edgecolor','k');
line(t,CCGMean,'linestyle','--','color','b');
line(t,Global(1)*ones(size(t)),'linestyle','--','color','m');
line(t,Global(2)*ones(size(t)),'linestyle','--','color','m');
line(t,Local(:,1),'linestyle','--','color','r')
line(t,Local(:,2),'linestyle','--','color','r')
box off;
xlim([min(t) max(t)]);
htitle = title(Title);
yl = get(gca, 'YLim');

hstruct.hbar = hbar;
hstruct.htitle = htitle;
end

