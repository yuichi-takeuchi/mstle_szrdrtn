function [ hs ] = eplpsyf_DetectionCheckFig1( segData, logicSum, ChLabel, ChOrder, Std, CoeffStd, sr, Title)
%
% Copyright (C) 2018 Yuichi Takeuchi

% Setting figure parameters
hfig = figure;
set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [0.5 0.5 16 12],... % [h distance, v distance, width, height], origin: left lower corner
    'PaperSize', [17 13]); % width, height

% Setting parameters for plot
x = (1:length(segData))./sr;

% Plotting
for i = 1:numel(ChLabel)
    hax = subplot(numel(ChLabel),1,i);
    set(hax,...
        'FontName', 'Arial',...
        'FontSize', 6);
    regsegData = segData(ChOrder{i}, :);
    plot(hax,x,regsegData, 'k');hold on
    yl = get(gca,'ylim');
    scaledLogicsum = logicSum*yl(2);
    plot(x, scaledLogicsum(i,:), 'r');
    for j = ChOrder{i}
        plot([0 x(end)], [Std(j)*CoeffStd(i) Std(j)*CoeffStd(i)], 'r');
        plot([0 x(end)], [-Std(j)*CoeffStd(i) -Std(j)*CoeffStd(i)], 'r');
    end
    patch(hax,[30 32 32 30],[yl(1) yl(1) yl(2) yl(2)], 'b', 'EdgeColor', 'none');
    hold off
    ylabel(gca,ChLabel{i});
end

%figure title
reptitle = strrep(Title, '_', '-');
axes;
htitle = title(reptitle);
axis off;

% Building handle sturcture
hs.hfig = hfig;
% hs.hylabel = hylabel;
% hs.htitle = htitle;


