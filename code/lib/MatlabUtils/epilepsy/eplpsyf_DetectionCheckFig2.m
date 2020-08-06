function [ hs ] = eplpsyf_DetectionCheckFig2( segData, segSmthd, logicSum, ChLabel, ChOrder, Rms, rmsCoeff, sr, Title)
%
% Copyright (C) 2018 Yuichi Takeuchi

% Setting figure parameters
hfig = figure;
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 16 12],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [17 13]); % width, height

% Setting parameters for plot
t = (1:length(segData))./sr;

% Plotting
for i = 1:numel(ChLabel)
    hax = subplot(numel(ChLabel),1,i);
    reorgsegData = segData(ChOrder{i}, :);
    plot(t,reorgsegData, 'k');hold on
    reorgsegSmthd = segSmthd(ChOrder{i}, :);
    plot(t,reorgsegSmthd, 'color', [0.75 0.75 0.75]);
    yl = get(gca,'ylim');
    scaledLogicsum = logicSum*yl(2);
    plot(t, scaledLogicsum(i,:), 'r');
    for j = ChOrder{i}
        plot([0 t(end)], [Rms(j)*rmsCoeff(i) Rms(j)*rmsCoeff(i)], 'b');
    end
    patch(hax,[30 32 32 30],[yl(1) yl(1) yl(2) yl(2)], 'y', 'EdgeColor', 'none');
    hold off
    set(hax,...
        'XLim', [0 max(t)],...
        'YTick', [],...
        'XTickLabel', [],...
        'XTick', [],...
        'XColor', 'none',...
        'FontName', 'Arial',...
        'FontSize', 6);
    ylabel(gca,ChLabel{i});
    % scale bar
    hold(hax,'on');
%     plot(hax, [max(t) max(t)],[yl(1) yl(1)+5], 'k', 'LineWidth', 2); % 5 mV
    plot(hax, [max(t)-10 max(t)],[yl(1) yl(1)], 'k', 'LineWidth', 2); % 10 s
    hold(hax,'off');
end

%figure title
reptitle = strrep(Title, '_', '-');
axes; htitle = title(reptitle); axis off;

% Building handle sturcture
hs.hfig = hfig;
% hs.hylabel = hylabel;
% hs.htitle = htitle;


