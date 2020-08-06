function [hstruct] = unf_RasterPlotDot(CluVec, Timestamp, CluID, fignum)
%
% Raster Plot
% [hstruct] = unf_RasterPlotDot(CluVec, Timestamp, CluID, fignum)
%
% INPUT:
%   CluVec: vector like .clu.0 file but without total no. cluster
%   Timestamp: vector like .res.0 file
%   CluID: Cluster No. (scalar or Vector)
%   fignum: figuerID (integer)
%   hstruct.hfig = hfig;
% hstruct.haxes = haxes;
% hstruct.hxlabel = hxlabel;
% hstruct.hylabel = hylabel;
% hstruct.htitle = htitle;
% hstruct.hlegend = hlegend; 
%
% Copyright (C) 2016 Yuichi Takeuchi
%


hfig = figure(fignum);
haxes = axes('Parent',hfig);
hold(haxes,'on');
counter = 1;
h = waitbar(0,'Plotting...');
for k = CluID
    waitbar(counter/length(CluID));
    Spkts = Timestamp(CluVec == k);
    % ./20000 time stamp in s
    x = double(Spkts)./20000;
    % defining marker shape etc.
    plot(x,counter,...
        'o','MarkerSize',1,...
        'MarkerFaceColor','k','MarkerEdgeColor','k');
    counter = counter + 1;
end

hxlabel = xlabel('Time (s)');
hylabel = ylabel('Cluster');
htitle = title('Raster');
hold(haxes,'off');

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



