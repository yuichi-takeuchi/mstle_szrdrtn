function [hstruct] = lfpf_spectrogramFFTSubP1(freq, srcMat, Time, fignum)
%
% lfpf_spectrogramFFT1 plots amplitude spectrogram.
%
% INPUTS:
%    freq: frequency vector
%    srcMat: Amplitude x Time course x Channels
%    Time: timestamp vector (s)
%    fignum: figure number (integer or vector)
%
% (c) Yuichi Takeuchi 2016

% srcMat = srcMat((freq>=1 & freq<=100),:,:);  %keep results btw 1 and 100 Hz only
% freq = freq((freq>=1 & freq<=100));  %keep results btw 1 and 100 Hz only

hfig = figure(fignum);
nChannels = size(srcMat,3);
nrow = ceil(sqrt(nChannels));
ncolumn = nrow;

% subtightplot
make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
if ~make_it_tight,  clear subplot;  end

% normalization
vmin = min(srcMat(:));
vmax = max(srcMat(:));
srcMat = 5e2*srcMat/vmax;

for k = 1:nChannels
    h.hfig = hfig;
    h.haxes = subplot(nrow, ncolumn, k);
%     pbaspect([1 1 1])
    h.hcm = colormap('jet');
    h.him = subimage(Time, freq, srcMat(:,:,k),h.hcm);
    axis normal
    pbaspect([2 1 1])

    h.hxlabel = xlabel('s');
    h.hylabel = ylabel('Hz');
    h.htitle = title(['ch' num2str(k)]);
%     h.hcb = colorbar;
    
    setfunc(h);
    
    hstruct(k).hfig = h.hfig;
    hstruct(k).him = h.him;
    hstruct(k).hcm = h.hcm;
%     hstruct(k).hcb = h.hcb;
    hstruct(k).haxes = h.haxes;
    hstruct(k).hxlabel = h.hxlabel;
    hstruct(k).hylabel = h.hylabel;
    hstruct(k).htitle = h.htitle;
end
tightfig;

function setfunc(h)
%
%
% Parameters
fontname = 'Arial';
fontsize = 1;

set(h.hfig,...
    'PaperUnits', 'centimeters',...
    'NumberTitle','on',...
    'Name','Amplitude of Spectrum'...
    );
        %     'PaperPosition', [1 1 50 50],...

% h.hcb.Label.String = 'amplitude';

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






