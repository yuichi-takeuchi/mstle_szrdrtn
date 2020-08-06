function [hstruct] = unf_PlotFiringRateMat(FiringRateMat,CluID,fignum)
%
% unf_PlotFiringRateMat plots Firing rate along time course.
%
% INPUTS:
%    FiringRateMat: timeseries x clusters x firing rate
%    CluID = ID of Clusters, scalar or vector
%    fignum: figuerID (integer)
%
% Copyright (C) 2016 Yuichi Takeuchi
%

LegendCell = cell(1, length(CluID));

hfig = figure(fignum);
haxes = axes('Parent',hfig);
hold(haxes,'on');
plot(haxes,FiringRateMat)
counter = 1;
h = waitbar(0,'Plotting...');
for k = CluID
    waitbar(counter/length(CluID));
    LegendCell{counter} = ['Cluster ' num2str(k)];
    counter = counter + 1;
end
hxlabel = xlabel('Time (s)');
hylabel = ylabel('Firing rate (Hz)');
htitle = title('Firing rate');
hlegend = legend(LegendCell);
hold(haxes,'off');

% Parameters
fontname = 'Arial';
fontsize = 8;

set(hfig,...
    'NumberTitle','on',...
    'Name','Firing rate'...
    );
%     'PaperUnits', 'centimeters',...
%     'PaperPosition', [7 7 12 9],...

% set(haxes,...
%     'FontName', fontname,...
%     'FontSize', fontsize...
%     );
%     'Ydir','reverse',...
%     'YLim',[0.5,counter - 0.5],...
%     'YTick',[1:counter - 1],...
%     'YTickLabel', ClusterLabel,...

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
hstruct.hlegend = hlegend;

close(h)
