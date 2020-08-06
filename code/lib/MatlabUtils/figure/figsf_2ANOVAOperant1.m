function [ flag ] = figsf_2ANOVAOperant1( sBasicStats, dataVarNames, condVec, CTitle, CXLabel, CYLabel, CLeg, colorMat, outputGraph, outputFileNameBase)
%
% control: 0 for open-loop and 1 for closed-loop
%
% (c) Yuichi Takeuchi 2018

close all
flag = 0;
for i = 1:length(dataVarNames)
    Mean = sBasicStats(i).Mean;
    Std = sBasicStats(i).Std;
    
    % building a plot
    [ hs ] = figf_PlotWEBLegend1( condVec, Mean', Std', CLeg, i); % srcMatX, srcMatY, srcMatEB, legendstr, fignum
    
    % setting parametors of bars and plots
    set(hs.heb, 'LineWidth', 0.75, 'MarkerSize', 4);
    set(hs.heb(1), 'YNegativeDelta',[], 'Color', colorMat(1,:)); % 'YNegativeDelta',[]
    set(hs.heb(2), 'YPositiveDelta',[], 'Color', colorMat(2,:)); % 'LineStyle', '--',
    set(hs.htitle, 'String', CTitle{i});
    set(hs.hxlabel, 'String', CXLabel{i}); 
    set(hs.hylabel, 'String', CYLabel{i});
    set(hs.hlgnd, 'Location','southwest');

    % global arameters
    fontname = 'Arial';
    fontsize = 5;

    % figure parameter settings
    set(hs.hfig,...
        'PaperUnits', 'centimeters',...
        'PaperPosition', [0.5 0.5 6 4],... % [h distance, v distance, width, height], origin: left lower corner
        'PaperSize', [7 5]... % width, height
        );
    
    yl = get(hs.hax, 'YLim');
    % axis parameter settings
    set(hs.hax,...
        'XLim', [min(condVec)-0.05, max(condVec)+0.05],...
        'XTick', condVec',...
        'YLim', [0, 110],... % 'YLim', [0, inf],...
        'YTick', [0 20 40 60 80 100],...
        'FontName', fontname,...
        'FontSize', fontsize...
        );

    % outputs
    if outputGraph(1)
        print([outputFileNameBase dataVarNames{i} '.pdf'], '-dpdf');
    end
    if outputGraph(2)
        print([outputFileNameBase dataVarNames{i} '.png'], '-dpng');
    end
end
flag = 1;