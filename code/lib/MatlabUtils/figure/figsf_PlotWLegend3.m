function [ flag ] = figsf_PlotWLegend3( srcX, srcMatY, CTitle, CHLabel, CVLabel, CLeg, outputGraph, outputFileNameBase)
%
% this is used to plot electome factor score timecourse
% 
% Copyright (c) Yuichi Takeuchi 2019

close all
flag = 0;

fignum = 1;

% building a plot
[ hs ] = figf_PlotWLegend3( srcX, srcMatY, CLeg, fignum );

% setting parametors of bars and plots
set(hs.hp, 'LineWidth', 0.5, 'MarkerSize', 5);
for i = 1:3
    set(hs.hp(i), 'Color', [(1 - 0.15*(i-1)) 0 0]);
end
for i = 4:10
    set(hs.hp(i), 'Color', [0 0 (1 - 0.075*(i-4))]);
end
set(hs.hylabel, 'String', CVLabel);
set(hs.hxlabel, 'String', CHLabel);
set(hs.htitle, 'String', CTitle);

% global parameters
fontname = 'Arial';
fontsize = 6;

% figure parameter settings
set(hs.hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 17 11],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [18 12]... % width, height
    );

% patch
yl = get(hs.hax, 'YLim');
% set(hs.h.ptch, 'YData', [yl(1); yl(1); yl(2); yl(2)]);

% axis parameter settings
set(hs.hax,... %     'YLim', yl,...
    'XLim', [-4 17],...
    'FontName', fontname,...
    'FontSize', fontsize...
    );
% 
%     'XTick', [1 2],...
%     'XTickLabel', {'Off', 'On'},...

set(hs.hlgnd,...
    'location', 'best',...
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