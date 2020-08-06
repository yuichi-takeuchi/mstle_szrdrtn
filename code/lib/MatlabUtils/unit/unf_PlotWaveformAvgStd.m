function [hstruct] = unf_PlotWaveformAvgStd(WaveformAvg, WaveformStd, fignum)
%
% Plot AvgWaveforms of Cluster
%
% [hstruct] = unf_PlotWaveformAvgStd(WaveformAvg, WaveformStd)
%
% INPUTS:
%    WaveformAvg: matrix (samples x channels)
%    WaveformStd: matrix (samples x channels)
%   fignum: figure number    
%    
% Copyright (C) 2017 Yuichi Takeuchi
%

% Parameters
fontname = 'Arial';
% fontsize = 8;

% getting number of channels
nChannels = size(WaveformAvg,2);
% making figure
hfig = figure(fignum);
hold on
% set(hfig,...
%     'NumberTitle','off');
%     'Name', num2str(fignum),...;
%     'PaperUnits', 'centimeters',...
%     'PaperPosition', [7 7 12 9],...

for i = 1:nChannels
    % subplot (5 plot per 1 column)
    haxes = subplot(ceil(nChannels/5),5,i);
    hold(haxes,'on');

    Meandata = WaveformAvg(:, i);
    StdPdata = Meandata + WaveformStd(:, i);
    StdNdata = Meandata - WaveformStd(:, i);
    plot(haxes, Meandata, 'k-')
    plot(haxes, StdPdata, 'k:')
    plot(haxes, StdNdata, 'k:')
    % consistent ylim
    set(haxes,...
        'XLim',[[1,length(Meandata)]],...
        'XTick', [],...
        'XTickLabel', [],...
        'YLim',[-300,300],...
        'YTick',[],...
        'YTickLabel', [],...
        'FontName', fontname...
    );
%         'FontSize', fontsize...
%     axis square
    htitle = title(['ch ' num2str(i)]);
end
hold(haxes,'off');
hold off

hstruct.hfig = hfig;
% hstruct.haxes = haxes;
% hstruct.hxlabel = hxlabel;
% hstruct.hylabel = hylabel;
% hstruct.htitle = htitle;
