function [hstruct] = lfpf_spectrogramFFT3(Freq, yo, Time, fignum)
%
% lfpf_spectrogramFFT3 plots periodgram of output of mtcsg.
%
% INPUTS:
%    Freq: frequency vector
%    yo: output of mtcsg (by Ken Harris)
%    Time: time vector
%    fignum: figure number
%
% (c) Yuichi Takeuchi 2016

hfig = figure(fignum);
him = imagesc(Time, Freq, 20*log10(abs(yo)+eps));
haxes = gca;
hold(haxes,'on');
hxlabel = xlabel('Time (s)');
hylabel = ylabel('Frequency (Hz)');
htitle = title('Periodogram');
hcm = colormap('jet');
hcb = colorbar;
hold(haxes,'off');

% Parameters
fontname = 'Arial';
fontsize = 8;

set(hfig,...
    'PaperUnits', 'centimeters',...
    'PaperPosition', [7 7 12 9],...
    'NumberTitle','on',...
    'Name','Periodogram'...
    );

hcb.Label.String = 'amplitude';

set(haxes,...
    'Layer', 'top',...
    'YLim',[0 250],...
    'Ydir','normal',...
    'FontName', fontname,...
    'FontSize', fontsize...
    );

%     'YTick',[1:length(CluID)],...
%     'YTickLabel', ClusterLabel,...

hstruct.hfig = hfig;
hstruct.him = him;
hstruct.hcm = hcm;
hstruct.hcb = hcb;
hstruct.haxes = haxes;
hstruct.hxlabel = hxlabel;
hstruct.hylabel = hylabel;
hstruct.htitle = htitle;
