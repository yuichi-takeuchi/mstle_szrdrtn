function [hstruct] = unf_RasterPlotLine(CluVec, Timestamp, CluID, fignum)
%
% Raster Plot
%
% INPUT:
%    CluVec: vector like .clu.0 file but without total no. cluster
%    Timestamp: vector like .res.0 file
%    CluID: Cluster No. (scalar or Vector)
%    fignum: figuerID (integer)
%
% Copyright (C) 2016 Yuichi Takeuchi
%

hfig = figure(fignum);
haxes = axes('Parent',hfig);
%ClusterLabel = '';
hold(haxes,'on');
counter = 1;
h = waitbar(0,'Plotting...');
for k = CluID
    waitbar(counter/length(CluID));
    Spkts = Timestamp(CluVec == k);
    nSpikes = numel(Spkts);
    % ./20000 time stamp in s
    Spkts = double(Spkts)./20000;
    for l = 1:nSpikes
       line([Spkts(l) Spkts(l)], [counter-0.5 counter+0.5],...
           'Color', 'k');
    end
    counter = counter + 1;
end

hxlabel = xlabel('Time (s)');
hylabel = ylabel('Cluster');
htitle = title('Raster');
% hlegend = legend(LegendCell);
hold(haxes,'off');

% 'Ydir','reverse' for inversion of y axis
% 'YTick'‚ tick for all cluster

% Parameters
fontname = 'Arial';
fontsize = 8;

set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [7 7 12 9],...
    'NumberTitle','on',...
    'Name','Raster'...
    );


ClusterLabel = int2str(CluID');
set(haxes,...
    'Ydir','reverse',...
    'YLim',[0.5,counter - 0.5],...
    'YTick',[1:length(CluID)],...
    'YTickLabel', ClusterLabel,...
    'FontName', fontname,...
    'FontSize', fontsize...
    );


set(hxlabel,...
    'HorizontalAlignment', 'center'...
    );

set(hylabel,...
    'HorizontalAlignment', 'center'...
    );


hstruct.hfig = hfig;
hstruct.haxes = haxes;
hstruct.hxlabel = hxlabel;
hstruct.hylabel = hylabel;
hstruct.htitle = htitle;
%hstruct.hlegend = hlegend;

close(h)