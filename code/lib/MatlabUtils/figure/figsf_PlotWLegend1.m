function [ flag ] = figsf_PlotWLegend1( srcX, srcMatY, CTitle, CVLabel, CLeg, outputGraph, outputFileNameBase)
%
% 
% Copyright (c) Yuichi Takeuchi 2018

close all
flag = 0;

fignum = 1;

% building a plot
[ hs ] = figf_PlotWLegend1( srcX, srcMatY, CLeg, fignum );

% setting parametors of bars and plots
set(hs.hp, 'LineWidth', 0.5, 'MarkerSize', 5);
set(hs.hp(1), 'Color', [0 0 0], 'Marker', 'o' );
set(hs.hp(2), 'Color', 'k', 'Marker', '.', 'MarkerSize', 15);
set(hs.hylabel, 'String', CVLabel);
set(hs.hxlabel, 'String', 'Time (s)');
set(hs.htitle, 'String', CTitle);

% global parameters
fontname = 'Arial';
fontsize = 8;

% figure parameter settings
set(hs.hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 8 8],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [9 9]... % width, height
    );

% patch
yl = get(hs.hax, 'YLim');
% set(hs.h.ptch, 'YData', [yl(1); yl(1); yl(2); yl(2)]);

% axis parameter settings
set(hs.hax,...
    'YLim', yl,...
    'XLim', [0 70],...
    'FontName', fontname,...
    'FontSize', fontsize...
    );
% 
%     'XTick', [1 2],...
%     'XTickLabel', {'Off', 'On'},...

% outputs
if outputGraph(1)
    print([outputFileNameBase '.pdf'], '-dpdf');
end
if outputGraph(2)
    print([outputFileNameBase '.png'], '-dpng');
end

flag = 1;