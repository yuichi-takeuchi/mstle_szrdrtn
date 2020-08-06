function [ hstruct ] = lfpf_spectrogramFFT1(freq, srcMat, Time, clim, fignum)
%
% lfpf_spectrogramFFT1 plots amplitude spectrogram.
%
% INPUTS:
%    freq: frequency vector
%    srcMat: Amplitude x Time course x Channels
%    Time: timestamp vector (s)
%    fignum: figure number (integer or vector)
%    clim: z limit
%
% (c) Yuichi Takeuchi 2016

% normalization
% vmin = min(srcMat(:));
% vmax = max(srcMat(:));
% srcMat = 5e2*srcMat/vmax;

h.hfig = figure(fignum);
h.him = imagesc(Time, freq, srcMat, clim);
h.haxes = gca;
hold(h.haxes,'on');
h.hxlabel = xlabel('Time (s)');
h.hylabel = ylabel('Frequency (Hz)');
h.htitle = title('Amplitude Spectrum');
h.hcm = colormap('jet');
h.hcb = colorbar;
hold(h.haxes,'off');

setfunc(h);

hstruct = h;

function setfunc(h)
%
%
% Parameters
fontname = 'Arial';
fontsize = 8;

set(h.hfig,...
    'PaperUnits', 'centimeters',...
    'NumberTitle','on',...
    'Name','Amplitude of Spectrum'...
    );
%    'PaperPosition', [7 7 12 9],...

h.hcb.Label.String = 'amplitude';

set(h.haxes,...
    'YLim',[1 625],...
    'Ydir','normal'...
      );
%     'Layer', 'top',...
%      'XTick', [],...
%      'XTickLabel', [],...
%     'Ydir','normal',...
%     'YTick',[],...
%     'YTickLabel', [],...
%     'FontName', fontname,...
%     'FontSize', fontsize...

%     'YTick',[1:length(CluID)],...
%     'YTickLabel', ClusterLabel,...


