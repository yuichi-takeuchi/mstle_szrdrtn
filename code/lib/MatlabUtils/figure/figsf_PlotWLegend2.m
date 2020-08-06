function [ flag ] = figsf_PlotWLegend2( srcX, srcMatY, CTitle, CHLabel, CVLabel, CLeg, outputGraph, outputFileNameBase)
%
% this is used to plot electome factor scores
% 
% Copyright (c) Yuichi Takeuchi 2018

close all
flag = 0;

fignum = 1;

% building a plot
[ hs ] = figf_PlotWLegend2( srcX, srcMatY, CLeg, fignum );

% setting parametors of bars and plots
set(hs.hp, 'LineWidth', 0.5, 'MarkerSize', 5);
set(hs.hp(1), 'Color', [1 0 0]);
set(hs.hp(2), 'Color', [0.80 0 0]);
set(hs.hp(3), 'Color', [0.60 0 0]);
set(hs.hp(4), 'Color', [0 0 1]);
set(hs.hp(5), 'Color', [0 0 0.80]);
set(hs.hp(6), 'Color', [0 0 0.60]);
set(hs.hylabel, 'String', CVLabel);
set(hs.hxlabel, 'String', CHLabel);
set(hs.htitle, 'String', CTitle);

% global parameters
fontname = 'Arial';
fontsize = 6;

% figure parameter settings
set(hs.hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 14 9],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [15 10]... % width, height
    );

% patch
yl = get(hs.hax, 'YLim');
% set(hs.h.ptch, 'YData', [yl(1); yl(1); yl(2); yl(2)]);

% axis parameter settings
set(hs.hax,... %     'YLim', yl,...
    'XLim', [0 3600],...
    'FontName', fontname,...
    'FontSize', fontsize...
    );
% 
%     'XTick', [1 2],...
%     'XTickLabel', {'Off', 'On'},...

set(hs.hlgnd,...
    'box', 'off'...
    );

% outputs
if outputGraph(1)
    print([outputFileNameBase '.pdf'], '-dpdf');
end
if outputGraph(2)
    print([outputFileNameBase '.png'], '-dpng');
end

flag = 1;