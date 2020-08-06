function [ hs ] = figf_VoltageTracesOfSubGroups1( t, data, ChGroup, ChLabel, fignum)
%
% Copyright (C) Yuichi Takeuchi 2018

hfig = figure(fignum);
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 16 12],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [17 13]); % width, height

maxChNo = max(cellfun(@length, ChGroup));

for GroupNo = 1:numel(ChLabel)
    hax = subplot(numel(ChLabel),1,GroupNo);

    % plot multipel traces
    [ hs ] = plotf_ScaledTraces1( hax, t, data, ChGroup{GroupNo});
    set(hax,...
        'YLim', [-maxChNo-6 maxChNo+6],...
        'YTickLabel', [],...
        'YTick', [],...
        'XTickLabel', [],...
        'XTick', [],...
        'XColor', 'none',...
        'XLim', [0 max(t)],...
        'FontName', 'Arial',...
        'FontSize', 6);

    % patch for stimulation timing
    yl = get(hax, 'YLim');
    hptch = patch(hax,[30 32 32 30],[yl(1) yl(1) yl(2) yl(2)],'r');
    set(hptch,...
        'FaceAlpha',0.5,...
        'EdgeColor', 'none');
    
    % group label
    ylabel(hax,ChLabel{GroupNo});
    
    % scale bar
    hold(hax,'on');
    plot(hax, [max(t) max(t)],[yl(1) yl(1)+5], 'k', 'LineWidth', 2); % 5 mV
    plot(hax, [max(t)-10 max(t)],[yl(1) yl(1)], 'k', 'LineWidth', 2); % 10 s
    hold(hax,'off');
%     axis off
end

