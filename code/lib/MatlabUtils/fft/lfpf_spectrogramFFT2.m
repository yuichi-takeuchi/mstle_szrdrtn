function [ hstruct ] = lfpf_spectrogramFFT2(freq, srcMat, Time, fignum)
%
% lfpf_spectrogramFFT2 plots power spectrogram.
%
% INPUTS:
%    freq: frequency vector
%    srcMat: Amplitude x Time course
%    Time: timestamp vector (s)
%    fignum: figure number
%
% (c) Yuichi Takeuchi 2016

hfig = figure(fignum);
him = imagesc(Time, freq, srcMat);
haxes = gca;
hold(haxes,'on');
hxlabel = xlabel('Time (s)');
hylabel = ylabel('Frequency (Hz)');
htitle = title('Power Spectrum');
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
    'Name','Power Spectrum'...
    );

hcb.Label.String = 'power';

set(haxes,...
    'Layer', 'top',...
    'YLim',[0 100],...
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


